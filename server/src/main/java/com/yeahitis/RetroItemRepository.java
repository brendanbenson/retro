package com.yeahitis;

import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface RetroItemRepository extends CrudRepository<RetroItem, Long> {
    List<RetroItem> findByRetroIdOrderByCreatedAt(String retroId);

}
