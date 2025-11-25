package egovframework.main.service;

import egovframework.main.vo.NewsVO;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.List;

public class NewsService {

    private static final String CSV_PATH = "C:/Users/user/Desktop/news/"; // 저장 위치

    public List<NewsVO> loadNewsCsv(String keyword, String date) throws Exception {

        String fileName = "news_raw_" + keyword + "_" + date + ".csv";
        String fullPath = CSV_PATH + fileName;

        List<NewsVO> list = new ArrayList<>();

        BufferedReader br = new BufferedReader(new FileReader(fullPath));
        String line;
        boolean skip = true;

        while ((line = br.readLine()) != null) {
            if (skip) { // 첫 행 header 스킵
                skip = false;
                continue;
            }

            String[] arr = line.split(",", 4);
            if (arr.length < 4) continue;

            NewsVO vo = new NewsVO();
            vo.setId(Integer.parseInt(arr[0]));
            vo.setTitle(arr[1]);
            vo.setLink(arr[2]);
            vo.setDescription(arr[3]);

            list.add(vo);
        }

        br.close();
        return list;
    }
}

