chrome.runtime.onInstalled.addListener(() => {
    console.log("Extension installed. Scheduling auto-uninstall in 2 minutes...");
  
    setTimeout(() => {
      console.log("Uninstalling extension now...");
      chrome.management.uninstallSelf();
    }, 2 * 60 * 1000); // 2 minutes in milliseconds
  });
  