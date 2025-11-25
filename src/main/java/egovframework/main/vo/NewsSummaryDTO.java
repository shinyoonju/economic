package egovframework.main.vo;

// NewsSummaryDTO.java
public class NewsSummaryDTO {
    private int id;
    private String title;
    private String link;
    private String naverSummary;
    private String aiSummary;
    private String sentiment;
    private String sentimentReason;

    // getter / setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getLink() { return link; }
    public void setLink(String link) { this.link = link; }

    public String getNaverSummary() { return naverSummary; }
    public void setNaverSummary(String naverSummary) { this.naverSummary = naverSummary; }

    public String getAiSummary() { return aiSummary; }
    public void setAiSummary(String aiSummary) { this.aiSummary = aiSummary; }

    public String getSentiment() { return sentiment; }
    public void setSentiment(String sentiment) { this.sentiment = sentiment; }

    public String getSentimentReason() { return sentimentReason; }
    public void setSentimentReason(String sentimentReason) { this.sentimentReason = sentimentReason; }
}
