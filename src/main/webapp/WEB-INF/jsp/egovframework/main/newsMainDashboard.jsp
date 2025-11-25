<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>Economy</title>
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
	<style>
		* { margin: 0; padding: 0; box-sizing: border-box; }

		body {
			font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
			background: #fafafa;
			min-height: 100vh;
			color: #1a1a1a;
		}

		.container { max-width: 1280px; margin: 0 auto; padding: 32px 24px; }

		/* 헤더 */
		.header {
			display: flex;
			justify-content: space-between;
			align-items: flex-end;
			margin-bottom: 32px;
		}

		.header h1 {
			font-size: 32px;
			font-weight: 700;
			color: #111;
			letter-spacing: -0.5px;
		}

		.header-time {
			font-size: 13px;
			color: #888;
		}

		/* 검색 */
		.search-section {
			background: #fff;
			border: 1px solid #e5e5e5;
			border-radius: 16px;
			padding: 24px;
			margin-bottom: 24px;
		}

		.search-box {
			display: flex;
			gap: 12px;
		}

		.search-input-wrapper {
			flex: 1;
			position: relative;
		}

		.search-input-wrapper i {
			position: absolute;
			left: 16px;
			top: 50%;
			transform: translateY(-50%);
			color: #999;
		}

		.search-input {
			width: 100%;
			padding: 14px 16px 14px 48px;
			background: #f5f5f5;
			border: 2px solid transparent;
			border-radius: 12px;
			font-size: 15px;
			color: #111;
			transition: all 0.2s;
		}

		.search-input:focus {
			outline: none;
			background: #fff;
			border-color: #111;
		}

		.search-input::placeholder { color: #aaa; }

		.search-btn {
			padding: 14px 32px;
			background: #111;
			border: none;
			border-radius: 12px;
			color: #fff;
			font-size: 15px;
			font-weight: 600;
			cursor: pointer;
			transition: all 0.2s;
		}

		.search-btn:hover { background: #333; }
		.search-btn.loading { opacity: 0.6; }

		.quick-tags {
			display: flex;
			gap: 8px;
			margin-top: 16px;
			flex-wrap: wrap;
		}

		.quick-tag {
			padding: 8px 16px;
			background: #f5f5f5;
			border: none;
			border-radius: 20px;
			font-size: 13px;
			color: #555;
			cursor: pointer;
			transition: all 0.2s;
		}

		.quick-tag:hover {
			background: #111;
			color: #fff;
		}

		/* 대시보드 */
		.dashboard { display: grid; grid-template-columns: 70% 30%; gap: 24px; }

		/* 뉴스 */
		.news-section {
			background: #fff;
			border: 1px solid #e5e5e5;
			border-radius: 16px;
			padding: 24px;
			min-height: 520px;
			display: flex;
			flex-direction: column;
		}

		.section-title {
			font-size: 14px;
			font-weight: 600;
			color: #888;
			text-transform: uppercase;
			letter-spacing: 1px;
			margin-bottom: 20px;
		}

		.news-list { flex: 1; overflow-y: auto; }

		.news-item {
			padding: 16px 0;
			border-bottom: 1px solid #f0f0f0;
			cursor: pointer;
			transition: all 0.15s;
		}

		.news-item:hover { padding-left: 8px; }
		.news-item:last-child { border-bottom: none; }

		.news-item-title {
			font-size: 15px;
			font-weight: 500;
			color: #222;
			line-height: 1.5;
		}

		.news-empty {
			flex: 1;
			display: flex;
			flex-direction: column;
			align-items: center;
			justify-content: center;
			color: #bbb;
		}

		.news-empty i { font-size: 48px; margin-bottom: 16px; }
		.news-empty p { font-size: 14px; }

		/* 시장 지수 */
		.markets-section {
			display: flex;
			flex-direction: column;
			gap: 12px;
		}

		.market-card {
			background: #fff;
			border: 1px solid #e5e5e5;
			border-radius: 14px;
			padding: 16px 18px;
			display: flex;
			justify-content: space-between;
			align-items: center;
			transition: all 0.2s;
		}

		.market-card:hover {
			box-shadow: 0 4px 12px rgba(0,0,0,0.06);
			transform: translateY(-2px);
		}

		.market-left { display: flex; align-items: center; gap: 12px; }
		.market-icon {
			width: 36px;
			height: 36px;
			border-radius: 10px;
			display: flex;
			align-items: center;
			justify-content: center;
			font-size: 16px;
			background: #f5f5f5;
		}

		.market-name {
			font-size: 13px;
			font-weight: 600;
			color: #333;
		}

		.market-right { text-align: right; }

		.market-value {
			font-size: 16px;
			font-weight: 700;
			color: #111;
			font-variant-numeric: tabular-nums;
		}

		.market-change {
			font-size: 12px;
			font-weight: 600;
			margin-top: 2px;
		}

		.rate-up { color: #e53935; }
		.rate-down { color: #1e88e5; }
		.rate-zero { color: #999; }

		.loading-shimmer {
			display: inline-block;
			width: 60px;
			height: 18px;
			background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
			background-size: 200% 100%;
			animation: shimmer 1.2s infinite;
			border-radius: 4px;
		}

		@keyframes shimmer {
			0% { background-position: 200% 0; }
			100% { background-position: -200% 0; }
		}

		@media (max-width: 960px) {
			.dashboard { grid-template-columns: 1fr; }
			.markets-section {
				display: grid;
				grid-template-columns: repeat(2, 1fr);
				order: -1;
			}
		}

		@media (max-width: 600px) {
			.markets-section { grid-template-columns: 1fr; }
			.search-box { flex-direction: column; }
		}
	</style>
</head>
<body>
<div class="container">
	<div class="header">
		<h3>실시간 경제 현황</h3>
		<div class="header-time">업데이트 :  <span id="currentTime"></span></div>
	</div>

	<div class="search-section">
		<div class="search-box">
			<div class="search-input-wrapper">
				<i class="fas fa-search"></i>
				<input type="text" id="keywordInput" class="search-input" placeholder="Search news by keyword..." />
			</div>
			<button id="searchBtn" class="search-btn" onclick="runPython()">검색</button>
		</div>
		<div class="quick-tags">
			<span class="quick-tag" onclick="quickSearch('코스피')">코스피</span>
			<span class="quick-tag" onclick="quickSearch('반도체')">반도체</span>
			<span class="quick-tag" onclick="quickSearch('AI')">AI</span>
			<span class="quick-tag" onclick="quickSearch('금리')">금리</span>
			<span class="quick-tag" onclick="quickSearch('비트코인')">비트코인</span>
			<span class="quick-tag" onclick="quickSearch('환율')">환율</span>
		</div>
	</div>

	<div class="dashboard">
		<div class="news-section">
			<div class="section-title"> 📰 최근 뉴스 TOP 10</div>
			<div id="newsListArea" class="news-list">
				<div class="news-empty">
					<i class="far fa-newspaper"></i>
					<p>잠시만 기다려주세요.</p>
				</div>
			</div>
		</div>

		<div class="markets-section">
			<div class="section-title">📈 지수</div>
			<div class="market-card">
				<div class="market-left">
					<div class="market-icon">🇰🇷</div>
					<div class="market-name">KOSPI</div>
				</div>
				<div class="market-right">
					<div id="kospiIndex" class="market-value"><span class="loading-shimmer"></span></div>
					<div id="kospiRate" class="market-change">-</div>
				</div>
			</div>
			<div class="market-card">
				<div class="market-left">
					<div class="market-icon">🇰🇷</div>
					<div class="market-name">KOSDAQ</div>
				</div>
				<div class="market-right">
					<div id="kosdaqIndex" class="market-value"><span class="loading-shimmer"></span></div>
					<div id="kosdaqRate" class="market-change">-</div>
				</div>
			</div>
			<div class="market-card">
				<div class="market-left">
					<div class="market-icon">🇺🇸</div>
					<div class="market-name">NASDAQ</div>
				</div>
				<div class="market-right">
					<div id="nasdaqIndex" class="market-value"><span class="loading-shimmer"></span></div>
					<div id="nasdaqRate" class="market-change">-</div>
				</div>
			</div>
			<div class="market-card">
				<div class="market-left">
					<div class="market-icon">🇺🇸</div>
					<div class="market-name">S&P 500</div>
				</div>
				<div class="market-right">
					<div id="spIndex" class="market-value"><span class="loading-shimmer"></span></div>
					<div id="spRate" class="market-change">-</div>
				</div>
			</div>
			<div class="market-card">
				<div class="market-left">
					<div class="market-icon" style="background:#f7931a22;color:#f7931a;">₿</div>
					<div class="market-name">Bitcoin</div>
				</div>
				<div class="market-right">
					<div id="btcPrice" class="market-value"><span class="loading-shimmer"></span></div>
					<div id="btcRate" class="market-change">-</div>
				</div>
			</div>
			<div class="market-card">
				<div class="market-left">
					<div class="market-icon" style="background:#627eea22;color:#627eea;">Ξ</div>
					<div class="market-name">Ethereum</div>
				</div>
				<div class="market-right">
					<div id="ethPrice" class="market-value"><span class="loading-shimmer"></span></div>
					<div id="ethRate" class="market-change">-</div>
				</div>
			</div>
		</div>
	</div>
</div>

<script>
	const ctx = "${pageContext.request.contextPath}";

	function updateTime() {
		const now = new Date();
		document.getElementById('currentTime').textContent = now.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' });
	}

	function loadMarketStatus() {
		$.ajax({
			url: ctx + "/marketStatusAjax.do",
			type: "GET",
			success: function (res) {
				updateTime();
				updateBox("#kospiIndex", "#kospiRate", res.kospiIndex, res.kospiRate);
				updateBox("#kosdaqIndex", "#kosdaqRate", res.kosdaqIndex, res.kosdaqRate);
				updateBox("#nasdaqIndex", "#nasdaqRate", res.nasdaqIndex, res.nasdaqRate);
				updateBox("#spIndex", "#spRate", res.spIndex, res.spRate);
				updateBox("#btcPrice", "#btcRate", res.btcPrice, res.btcRate, '$');
				updateBox("#ethPrice", "#ethRate", res.ethPrice, res.ethRate, '$');
			},
			error: function () { console.log("marketStatusAjax 호출 실패"); }
		});
	}

	function updateBox(indexSel, rateSel, price, rate, prefix = '') {
		$(indexSel).text(prefix + numberWithComma(price));
		const rateElem = $(rateSel);
		rateElem.removeClass('rate-up rate-down rate-zero');

		let cls = 'rate-zero', arrow = '';
		if (rate > 0) { cls = 'rate-up'; arrow = '▲ '; }
		else if (rate < 0) { cls = 'rate-down'; arrow = '▼ '; }

		rateElem.addClass(cls).text(arrow + Math.abs(rate).toFixed(2) + '%');
	}

	function numberWithComma(x) {
		if (!x) return '-';
		return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}

	function quickSearch(keyword) {
		$("#keywordInput").val(keyword);
		runPython();
	}

	function runPython() {
		const kw = $("#keywordInput").val().trim();
		if (!kw) { alert("키워드를 입력해주세요."); return; }

		const $btn = $("#searchBtn");
		$btn.addClass('loading').text('검색중...');

		$.ajax({
			url: ctx + "/runPython.do",
			type: "GET",
			data: { keyword: kw },
			success: function() {
				$btn.removeClass('loading').text('Search');
				loadNews();
			},
			error: function() {
				$btn.removeClass('loading').text('Search');
				alert("검색 중 오류가 발생했습니다.");
			}
		});
	}

	function loadNews() {
		$.ajax({
			url: ctx + "/loadNewsAjax.do",
			type: "GET",
			data: { keyword: "", date: "" },
			success: function (res) {
				if (!res || res.length === 0) {
					$("#newsListArea").html('<div class="news-empty"><i class="far fa-folder-open"></i><p>No results found</p></div>');
					return;
				}
				let html = "";
				res.forEach(function (n) {
					const link = typeof n.link === "string" ? n.link : (n.link?.value || n.link?.[0] || "");
					const title = typeof n.title === "string" ? n.title : (n.title?.value || "");
					html += `<div class="news-item" onclick="window.open('\${link}', '_blank')"><div class="news-item-title">\${title}</div></div>`;
				});
				$("#newsListArea").html(html);
			},
			error: function () {
				$("#newsListArea").html('<div class="news-empty"><i class="fas fa-exclamation-circle"></i><p>Failed to load</p></div>');
			}
		});
	}

	$("#keywordInput").on('keypress', function(e) { if (e.which === 13) runPython(); });

	$(function() {
		updateTime();
		loadMarketStatus();
		loadNews();
		setInterval(loadMarketStatus, 5000);
		setInterval(updateTime, 1000);
	});
</script>
</body>
</html>