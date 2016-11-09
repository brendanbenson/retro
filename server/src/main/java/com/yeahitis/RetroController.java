package com.yeahitis;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Date;
import java.util.List;

import static java.util.stream.Collectors.toList;

@Controller
public class RetroController {
    @Autowired
    private RetroItemRepository retroItemRepository;

    @RequestMapping("/api/retros/{retroId}")
    @ResponseBody
    public List<RetroItemDto> get(@PathVariable String retroId) {
        return retroItemRepository
                .findByRetroIdOrderByCreatedAt(retroId)
                .stream()
                .map(RetroItemDto::new)
                .collect(toList());
    }

    @MessageMapping("/chat/{retroId}")
    @SendTo("/topic/{retroId}")
    public List<RetroItemDto> send(
            @DestinationVariable String retroId,
            final Message message
    ) throws Exception {
        retroItemRepository.save(
                new RetroItem(
                        retroId,
                        message.getText(),
                        RetroItemType.valueOf(message.getSentiment()),
                        null,
                        null
                )
        );

        return retroItemRepository
                .findByRetroIdOrderByCreatedAt(retroId)
                .stream()
                .map(RetroItemDto::new)
                .collect(toList());
    }

    @MessageMapping("/chat/{retroId}/items/{itemId}/finish")
    @SendTo("/topic/{retroId}")
    public List<RetroItemDto> markAsFinished(
            @DestinationVariable String retroId,
            @DestinationVariable Long itemId
    ) throws Exception {
        RetroItem retroItem = retroItemRepository.findOne(itemId);
        retroItem.setFinishedAt(new Date());
        retroItemRepository.save(retroItem);

        return retroItemRepository
                .findByRetroIdOrderByCreatedAt(retroId)
                .stream()
                .map(RetroItemDto::new)
                .collect(toList());
    }

    @MessageMapping("/chat/{retroId}/items/{itemId}/unfinish")
    @SendTo("/topic/{retroId}")
    public List<RetroItemDto> markAsUnfinished(
            @DestinationVariable String retroId,
            @DestinationVariable Long itemId
    ) throws Exception {
        RetroItem retroItem = retroItemRepository.findOne(itemId);
        retroItem.setFinishedAt(null);
        retroItemRepository.save(retroItem);

        return retroItemRepository
                .findByRetroIdOrderByCreatedAt(retroId)
                .stream()
                .map(RetroItemDto::new)
                .collect(toList());
    }
}
