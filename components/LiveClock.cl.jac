import from react { useEffect }

def:pub LiveClock() -> JsxElement {
    has date_label: str = "Sri Lanka";
    has time_label: str = "";
    has iso_stamp: str = "";
    def update_clock() -> None {
        now: any = new(Date);
        date_label = str(now.toLocaleDateString("en-GB", {"timeZone": "Asia/Colombo", "weekday": "short", "day": "numeric", "month": "short", "year": "numeric"}));
        time_label = str(now.toLocaleTimeString("en-GB", {"timeZone": "Asia/Colombo", "hour": "2-digit", "minute": "2-digit", "second": "2-digit", "hour12": False}));
        iso_stamp = str(now.toISOString());
    }
    useEffect(lambda {
        update_clock();
        timer = setInterval(update_clock, 1000);
        return lambda { clearInterval(timer); };
    }, []);
    return <div className="local-clock" aria-label="Current date and time in Sri Lanka"><span>{date_label}</span><time dateTime={iso_stamp} aria-live="off">{time_label}<small>Asia/Colombo</small></time></div>;
}
