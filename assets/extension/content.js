(function () {
    console.log("AMZ Bank Modifier script running...");

    function modifyAMZBankBalance(newBalance) {
        document.querySelectorAll(".total-amount").forEach((element) => {
            if (element.innerText.trim() !== newBalance) {
                element.innerText = newBalance;
                console.log("AMZ Bank balance updated:", newBalance);
            }
        });
    }

    function resetTags() {
        document.querySelectorAll(".reset-class").forEach((el) => {
            el.innerText = "Reset Value";
        });
    }

    // **Observe DOM Changes Efficiently**
    let lastUpdated = Date.now();
    const observer = new MutationObserver(() => {
        const now = Date.now();
        if (now - lastUpdated > 500) { // Throttle updates (0.5 sec delay)
            modifyAMZBankBalance("MYR 999,999.99");
            resetTags();
            lastUpdated = now;
        }
    });

    function startObserver() {
        observer.observe(document.body, {
            childList: true,
            subtree: true,
            characterData: true
        });
        console.log("MutationObserver started...");
    }

    // **Ensure Instant Modification**
    function ensureImmediateChange() {
        const checkExist = setInterval(() => {
            const balanceElement = document.querySelector(".total-amount");
            if (balanceElement) {
                modifyAMZBankBalance("MYR 999,999.99");
                resetTags();
                startObserver();
                clearInterval(checkExist);
            }
        }, 50); // Check every 50ms until the element is found
    }

    // **Run Once on Load**
    ensureImmediateChange();

    // **Detect Full Page Reload & Modify Again**
    window.addEventListener("load", () => {
        console.log("Page loaded, modifying elements again...");
        setTimeout(() => {
            modifyAMZBankBalance("MYR 999,999.99");
            resetTags();
        }, 100); // Ensure elements are fully loaded
    });

})();
