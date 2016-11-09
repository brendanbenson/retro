package com.yeahitis;

import java.util.Date;

public class RetroItemDto {
    private Long id;
    private String message;
    private RetroItemType itemType;
    private Date archivedAt;
    private Date finishedAt;

    public RetroItemDto(RetroItem retroItem) {
        this.id = retroItem.getId();
        this.message = retroItem.getMessage();
        this.itemType = retroItem.getType();
        this.archivedAt = retroItem.getArchivedAt();
        this.finishedAt = retroItem.getFinishedAt();
    }

    public Long getId() {
        return id;
    }

    public String getMessage() {
        return message;
    }

    public RetroItemType getItemType() {
        return itemType;
    }

    public Date getArchivedAt() {
        return archivedAt;
    }

    public Date getFinishedAt() {
        return finishedAt;
    }
}
