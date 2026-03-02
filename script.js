/* jshint esversion: 8, -W014 */

const REPO = "hafiz-muhammad/configs";
const BRANCH = "main";

// Get data from GitHub API
async function getRepo() {
    try {
        const response = await fetch(`https://api.github.com/repos/${REPO}/git/trees/${BRANCH}?recursive=1`);

        if (!response.ok) {
            throw new Error("Rate limit exceeded or Repo not found");
        }

        const data = await response.json();
        document.getElementById("loading").style.display = "none";
        buildTree(data.tree);
    } catch (err) {
        document.getElementById("loading").innerText = "Error: " + err.message;
    }
}

// Make flat list into a tree
function buildTree(files) {
    const root = {};

    files.forEach((file) => {
        const parts = file.path.split("/");
        let curr = root;

        parts.forEach((part, i) => {
            const isLast = i === parts.length - 1;

            if (!curr[part]) {
                curr[part] =
                    isLast && file.type === "blob"
                        ? { isFile: true, path: file.path }
                        : { isFile: false, path: file.path, children: {} };
            }

            curr = curr[part].isFile ? curr[part] : curr[part].children;
        });
    });

    const treeEl = document.getElementById("tree");
    treeEl.innerHTML = "";
    treeEl.appendChild(makeList(root));
}

// Recursive function to build the UI
function makeList(obj) {
    const ul = document.createElement("ul");
    ul.className = "nested";

    const keys = Object.keys(obj).sort((a, b) => {
        if (obj[a].isFile !== obj[b].isFile) {
            return obj[a].isFile ? 1 : -1;
        }
        return a.localeCompare(b);
    });

    for (const key of keys) {
        const li = document.createElement("li");
        const item = obj[key];

        if (item.isFile) {
            const url = `https://github.com/${REPO}/blob/${BRANCH}/${item.path}`;
            li.innerHTML = `
                <div class="file">
                    <span class="icon">📄</span>
                    <a href="${url}" target="_blank">${key}</a>
                </div>
            `;
        } else {
            const folderWrap = document.createElement("div");
            folderWrap.className = "folder-header";

            const folderIcon = document.createElement("span");
            folderIcon.className = "icon folder-toggle";
            folderIcon.innerText = "📂"; 

            const url = `https://github.com/${REPO}/tree/${BRANCH}/${item.path}`;
            const link = document.createElement("a");
            link.href = url;
            link.target = "_blank";
            link.className = "folder-name";
            link.innerText = key;

            folderWrap.appendChild(folderIcon);
            folderWrap.appendChild(link);
            li.appendChild(folderWrap);

            if (Object.keys(item.children).length > 0) {
                const nestedUl = makeList(item.children);
                li.appendChild(nestedUl);

                folderIcon.addEventListener("click", (e) => {
                    e.preventDefault();
                    nestedUl.classList.toggle("collapsed");
                    folderIcon.innerText = nestedUl.classList.contains("collapsed") ? "📁" : "📂";
                });
            }
        }
        ul.appendChild(li);
    }
    return ul;
}

getRepo();