package com.example.springDemoHW.controllers;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.time.ZonedDateTime;

@Controller
public class MainController {
    private static final Logger logger = LoggerFactory.getLogger(MainController.class);
    @GetMapping("/")
    public String root(Model model) {
        logger.info("GET request received for \"/\"");

        try {
            model.addAttribute("time", ZonedDateTime.now());
        } catch (RuntimeException e){
            logger.error("RuntimeException in root", e);
        }

        return "main";
    }

    @GetMapping("/err")
    public String err(Model model) {
        logger.info("GET request received for \"/err\"");

        try {
            simulate();
        } catch (NullPointerException e) {
            logger.error("npm test", e);
        }

        return "err";
    }

    @GetMapping("/testlogs")
    public String testlogs(Model model) {
//        logger.info("GET request received for \"/testlogs\"");

        for (int i = 0; i < 1000; i++) {
            logger.info("THIS IS TEST RECORD #" + i);
        }

        return "testlogs";
    }

    public int simulate() throws NullPointerException{
        throw new NullPointerException("NPM EXCEPTION TEST");
    }
}
