/*
 * Copyright 2008-2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package egovframework.main.web;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.opencsv.CSVReader;
import egovframework.main.service.NewsMainService;


import egovframework.rte.fdl.property.EgovPropertyService;

import javax.annotation.Resource;

import org.json.simple.parser.JSONParser;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springmodules.validation.commons.DefaultBeanValidator;

/**
 * @Class Name : EgovSampleController.java
 * @Description : EgovSample Controller Class
 * @Modification Information
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2009.03.16           최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 *  Copyright (C) by MOPAS All right reserved.
 */

@Controller
public class NewsMainController {

	private static final String CSV_PATH = "C:/Users/user/"; // CSV 저장 위치


	/**
	 * 메인 화면
	 * @param
	 * @param model
	 * @return "newsMainDashboard"
	 * @exception Exception
	 */
	@RequestMapping(value = "/main.do")
	public String newsMain(Model model) throws Exception {
		return "main/newsMainDashboard";
	}


	@ResponseBody
	@RequestMapping("/marketStatusAjax.do")
	public Map<String, Object> marketAjax() throws Exception {

		Map<String, Object> result = new HashMap<>();
		JSONParser parser = new JSONParser();

		// ---- 1. KOSPI ----
		JSONObject kospiJson = getJson("https://query1.finance.yahoo.com/v8/finance/chart/%5EKS11");
		JSONObject kospiMeta = (JSONObject) ((JSONObject) ((JSONArray) ((JSONObject) kospiJson.get("chart"))
				.get("result")).get(0)).get("meta");

		double kospiIndex = safeDouble(kospiMeta.get("regularMarketPrice"));
		double kospiRate = safeDouble(kospiMeta.get("regularMarketChangePercent"));

		// ---- 2. KOSDAQ ----
		JSONObject kosdaqJson = getJson("https://query1.finance.yahoo.com/v8/finance/chart/%5EKQ11");
		JSONObject kosdaqMeta = (JSONObject) ((JSONObject) ((JSONArray) ((JSONObject) kosdaqJson.get("chart"))
				.get("result")).get(0)).get("meta");

		double kosdaqIndex = safeDouble(kosdaqMeta.get("regularMarketPrice"));
		double kosdaqRate = safeDouble(kosdaqMeta.get("regularMarketChangePercent"));

		// ---- 3. NASDAQ ----
		JSONObject nasdaqJson = getJson("https://query1.finance.yahoo.com/v8/finance/chart/%5EIXIC");
		JSONObject nasdaqMeta = (JSONObject) ((JSONObject) ((JSONArray) ((JSONObject) nasdaqJson.get("chart"))
				.get("result")).get(0)).get("meta");

		double nasdaqIndex = safeDouble(nasdaqMeta.get("regularMarketPrice"));
		double nasdaqRate = safeDouble(nasdaqMeta.get("regularMarketChangePercent"));

		// ---- 4. S&P 500 ----
		// 반드시 인코딩된 %5EGSPC 사용해야 정상!
		JSONObject spJson = getJson("https://query1.finance.yahoo.com/v8/finance/chart/%5EGSPC");
		JSONObject spMeta = (JSONObject) ((JSONObject) ((JSONArray) ((JSONObject) spJson.get("chart"))
				.get("result")).get(0)).get("meta");

		double spIndex = safeDouble(spMeta.get("regularMarketPrice"));
		double spRate = safeDouble(spMeta.get("regularMarketChangePercent"));

		// ---- 5. BTC (Upbit) ----
		JSONArray btcArr = getJsonArray("https://api.upbit.com/v1/ticker?markets=KRW-BTC");
		JSONObject btcObj = (JSONObject) btcArr.get(0);

		double btcPrice = safeDouble(btcObj.get("trade_price"));
		double btcRate = safeDouble(btcObj.get("signed_change_rate")) * 100;

		// ---- 6. ETH (Upbit) ----
		JSONArray ethArr = getJsonArray("https://api.upbit.com/v1/ticker?markets=KRW-ETH");
		JSONObject ethObj = (JSONObject) ethArr.get(0);

		double ethPrice = safeDouble(ethObj.get("trade_price"));
		double ethRate = safeDouble(ethObj.get("signed_change_rate")) * 100;

		// ---- 결과 맵 저장 ----
		result.put("kospiIndex", kospiIndex);
		result.put("kospiRate", kospiRate);

		result.put("kosdaqIndex", kosdaqIndex);
		result.put("kosdaqRate", kosdaqRate);

		result.put("nasdaqIndex", nasdaqIndex);
		result.put("nasdaqRate", nasdaqRate);

		result.put("spIndex", spIndex);
		result.put("spRate", spRate);

		result.put("btcPrice", btcPrice);
		result.put("btcRate", btcRate);

		result.put("ethPrice", ethPrice);
		result.put("ethRate", ethRate);

		return result;
	}



	@RequestMapping("/runPython.do")
	@ResponseBody
	public String runPython(@RequestParam String keyword) throws Exception {

		String pythonExe = "C:/Users/user/miniconda3/python.exe";   // ⭐ 윤주 PC 파이썬 경로
		String scriptPath = "C:/Users/user/news_to_csv.py";          // ⭐ 파이썬 스크립트 경로

		ProcessBuilder pb = new ProcessBuilder(
				pythonExe,
				scriptPath,
				keyword   // 파이썬에 전달할 인자
		);

		pb.redirectErrorStream(true);
		Process p = pb.start();

		BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream()));
		String line;
		while ((line = br.readLine()) != null) {
			System.out.println("PYTHON >> " + line);
		}

		p.waitFor();
		return "OK";
	}

	@ResponseBody
	@RequestMapping("/loadNewsAjax.do")
	public List<Map<String, Object>> loadNewsAjax(
			@RequestParam(required = false) String keyword,
			@RequestParam(required = false) String date
	) throws Exception {

		if (keyword == null || keyword.trim().isEmpty()) {
			keyword = "경제";
		}

		if (date == null || date.trim().isEmpty()) {
			date = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
		}

		String file = CSV_PATH + "news_raw" + ".csv";

		List<Map<String, Object>> list = new ArrayList<>();

		try (CSVReader reader = new CSVReader(new InputStreamReader(new FileInputStream(file), "UTF-8"))) {

			String[] arr;
			boolean skipHeader = true;

			while ((arr = reader.readNext()) != null) {

				if (skipHeader) {
					skipHeader = false;
					continue;
				}

				if (arr.length < 4) continue;  // 안전 체크

				Map<String, Object> map = new HashMap<>();
				map.put("id", arr[0]);
				map.put("title", arr[1]);
				map.put("link", arr[2]);
				map.put("description", arr[3]);

				list.add(map);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	// ----- HttpJsonUtil 대체 -----
	public static JSONObject getJson(String urlStr) {
		try {
			URL url = new URL(urlStr);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();

			conn.setRequestMethod("GET");
			conn.setRequestProperty("User-Agent", "Mozilla/5.0");
			conn.setRequestProperty("Accept", "application/json");

			BufferedReader br = new BufferedReader(
					new InputStreamReader(conn.getInputStream(), "UTF-8")
			);

			StringBuilder sb = new StringBuilder();
			String line;
			while ((line = br.readLine()) != null) {
				sb.append(line);
			}
			br.close();

			return (JSONObject) new org.json.simple.parser.JSONParser().parse(sb.toString());

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}


	private JSONArray getJsonArray(String urlStr) throws Exception {
		String raw = get(urlStr);
		JSONParser parser = new JSONParser();
		return (JSONArray) parser.parse(raw);
	}

	private String get(String urlStr) throws Exception {
		URL url = new URL(urlStr);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setConnectTimeout(5000);
		conn.setReadTimeout(5000);

		BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
		StringBuilder sb = new StringBuilder();

		String line;
		while ((line = br.readLine()) != null) sb.append(line);
		return sb.toString();
	}


	private double safeDouble(Object obj) {
		if (obj == null) return 0;
		if (obj instanceof Number) return ((Number)obj).doubleValue();
		try {
			return Double.parseDouble(obj.toString());
		} catch (Exception e) {
			return 0;
		}
	}



}
