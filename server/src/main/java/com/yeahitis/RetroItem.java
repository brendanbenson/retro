package com.yeahitis;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "retro_items")
public class RetroItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String retroId;
    private String message;

    @Enumerated(EnumType.STRING)
    private RetroItemType type;

    private Date archivedAt;
    private Date finishedAt;

    @Column(insertable = false, updatable = false)
    private Date createdAt;


    protected RetroItem() {
    }

    public RetroItem(
            String retroId,
            String message,
            RetroItemType itemType,
            Date archivedAt,
            Date finishedAt
    ) {
        this.retroId = retroId;
        this.message = message;
        this.type = itemType;
        this.archivedAt = archivedAt;
        this.finishedAt = finishedAt;
    }

    public Long getId() {
        return id;
    }

    public String getRetroId() {
        return retroId;
    }

    public String getMessage() {
        return message;
    }

    public RetroItemType getType() {
        return type;
    }

    public Date getArchivedAt() {
        return archivedAt;
    }

    public Date getFinishedAt() {
        return finishedAt;
    }

    public void setFinishedAt(Date finishedAt) {
        this.finishedAt = finishedAt;
    }

    public Date getCreatedAt() {
        return createdAt;
    }
}
