package com.yeahitis;

public class OutputMessage {
    private final String from;
    private final String text;
    private final String time;
    private final String sentiment;

    public OutputMessage(String from, String text, String time, String sentiment) {
        this.from = from;
        this.text = text;
        this.time = time;
        this.sentiment = sentiment;
    }

    public String getFrom() {
        return from;
    }

    public String getText() {
        return text;
    }

    public String getTime() {
        return time;
    }

    public String getSentiment() {
        return sentiment;
    }
}
