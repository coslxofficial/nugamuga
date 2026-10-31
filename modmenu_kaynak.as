
// ================= MOD MENU (Insert veya ` ile ac/kapat) =================
if (_root.__mod == undefined) {
   _root.__mod = new Object();
   var M = _root.__mod;
   M.gn = [@@GUNNAMES@@];
   M.on = new Object();
   M.spd = 1;
   M.gun = 10;
   M.tab = 0;
   M.open = false;
   M.fc = 0;
   M.tabs = ["OYUNCU", "SİLAH", "DÜNYA", "BOTLAR", "KAYIT"];

   // ---------- yardimcilar ----------
   M.rect = function(mc, x, y, w, h, c, a) {
      mc.beginFill(c, a);
      mc.moveTo(x, y);
      mc.lineTo(x + w, y);
      mc.lineTo(x + w, y + h);
      mc.lineTo(x, y + h);
      mc.lineTo(x, y);
      mc.endFill();
   };
   M.txt = function(mc, nm, d, x, y, w, h, s, sz, col, bold, al) {
      mc.createTextField(nm, d, x, y, w, h);
      var t = mc[nm];
      t.selectable = false;
      var f = new TextFormat();
      f.font = "_sans";
      f.size = sz;
      f.color = col;
      f.bold = bold;
      f.align = al;
      t.text = s;
      t.setTextFormat(f);
      return t;
   };
   M.humans = function() {
      var r = new Array();
      var a = _root.activeplayers;
      for (var i = 0; i < a.length; i++) {
         if (a[i] != undefined && !a[i].AI && a[i].lives > 0) {
            r.push(a[i]);
         }
      }
      return r;
   };
   M.bots = function() {
      var r = new Array();
      var a = _root.activeplayers;
      for (var i = 0; i < a.length; i++) {
         if (a[i] != undefined && a[i].AI && a[i].lives > 0) {
            r.push(a[i]);
         }
      }
      return r;
   };
   M.flush = function() {
      _root.savedata.flush();
   };

   // ---------- sayisal deger okuma/yazma ----------
   M.g_spd = function() { return "x" + _root.__mod.spd; };
   M.s_spd = function(d) {
      var m = _root.__mod;
      m.spd = Math.round((m.spd + d * 0.5) * 10) / 10;
      if (m.spd < 1) { m.spd = 1; }
      if (m.spd > 6) { m.spd = 6; }
   };
   M.g_gun = function() { var m = _root.__mod; return m.gun + " - " + m.gn[m.gun - 1]; };
   M.s_gun = function(d) {
      var m = _root.__mod;
      m.gun += d;
      if (m.gun < 1) { m.gun = 86; }
      if (m.gun > 86) { m.gun = 1; }
   };
   M.g_gun10 = function() { return "±10"; };
   M.s_gun10 = function(d) {
      var m = _root.__mod;
      m.gun += d * 10;
      if (m.gun < 1) { m.gun = 86; }
      if (m.gun > 86) { m.gun = 1; }
   };
   M.g_grav = function() { return String(Math.round(_root.gravity * 100) / 100); };
   M.s_grav = function(d) {
      var v = Math.round((_root.gravity + d * 0.1) * 100) / 100;
      if (v < -1) { v = -1; }
      if (v > 3) { v = 3; }
      _root.gravity = v;
   };
   M.g_jump = function() { return String(Math.round(_root.power * 10) / 10); };
   M.s_jump = function(d) {
      var v = _root.power + d * 1.5;
      if (v < 4) { v = 4; }
      if (v > 45) { v = 45; }
      _root.power = v;
   };
   M.g_fric = function() { return String(Math.round(_root.friction * 100) / 100); };
   M.s_fric = function(d) {
      var v = Math.round((_root.friction + d * 0.02) * 100) / 100;
      if (v < 0.5) { v = 0.5; }
      if (v > 0.99) { v = 0.99; }
      _root.friction = v;
   };

   // ---------- butonlar ----------
   M.f_equip = function() {
      var m = _root.__mod;
      var h = m.humans();
      for (var i = 0; i < h.length; i++) {
         h[i].getgun(m.gun);
         h[i].defaultgun = m.gun;
      }
   };
   M.f_equipbots = function() {
      var m = _root.__mod;
      var b = m.bots();
      for (var i = 0; i < b.length; i++) {
         b[i].getgun(m.gun);
         b[i].defaultgun = m.gun;
      }
   };
   M.f_randgun = function() {
      var m = _root.__mod;
      m.gun = random(77) + 10;
      m.f_equip();
   };
   M.f_nextgun = function() {
      var m = _root.__mod;
      m.s_gun(1);
      m.f_equip();
   };
   M.f_botrand = function() {
      var b = _root.__mod.bots();
      for (var i = 0; i < b.length; i++) {
         var g = random(77) + 10;
         b[i].getgun(g);
         b[i].defaultgun = g;
      }
   };
   M.f_killbots = function() {
      var b = _root.__mod.bots();
      for (var i = b.length - 1; i >= 0; i--) {
         b[i].gotkilled();
      }
   };
   M.f_elimbots = function() {
      var b = _root.__mod.bots();
      for (var i = b.length - 1; i >= 0; i--) {
         b[i].lives = 1;
         b[i].gotkilled();
      }
   };
   M.f_botlife1 = function() {
      var b = _root.__mod.bots();
      for (var i = 0; i < b.length; i++) {
         b[i].lives = 1;
      }
   };
   M.f_bring = function() {
      var m = _root.__mod;
      var h = m.humans();
      var b = m.bots();
      if (h.length == 0) { return; }
      for (var i = 0; i < b.length; i++) {
         b[i]._x = h[0]._x + (i - b.length / 2) * 30;
         b[i]._y = h[0]._y - 10;
         b[i].vx = 0;
         b[i].vy = 0;
      }
   };
   M.f_lives10 = function() {
      var h = _root.__mod.humans();
      for (var i = 0; i < h.length; i++) {
         h[i].lives += 10;
         h[i].lifebling();
      }
   };
   M.f_center = function() {
      var h = _root.__mod.humans();
      for (var i = 0; i < h.length; i++) {
         h[i]._x = _root.ground._x + _root.ground.spawnarea._x + _root.ground.spawnarea._width / 2;
         h[i]._y = -300;
         h[i].vx = 0;
         h[i].vy = 0;
      }
   };
   M.f_crate = function() {
      if (_root.ground != undefined) {
         _root.CP("crate", _root.ground._x + _root.ground.cratearea._x + random(_root.ground.cratearea._width), -300, 0, 0);
      }
   };
   M.f_crate10 = function() {
      for (var i = 0; i < 10; i++) {
         _root.__mod.f_crate();
      }
   };
   M.f_powerup = function() {
      var h = _root.__mod.humans();
      if (h.length == 0) { return; }
      _root.CP("powerup", h[0]._x + random(240) - 120, h[0]._y - 70, 0, 0);
   };
   M.f_powerup7 = function() {
      for (var i = 0; i < 7; i++) {
         _root.__mod.f_powerup();
      }
   };
   M.f_unlockm = function() {
      var d = _root.savedata.data.campaign;
      for (var i = 0; i < d.length; i++) {
         if (d[i] == 0) { d[i] = 1; }
      }
      _root.__mod.flush();
      _root.__mod.msg = "Tüm görevler açıldı!";
   };
   M.f_completem = function() {
      var d = _root.savedata.data.campaign;
      for (var i = 0; i < d.length; i++) {
         d[i] = 2;
      }
      _root.__mod.flush();
      _root.__mod.msg = "Tüm görevler tamamlandı!";
   };
   M.f_challenges = function() {
      var d = _root.savedata.data.challenge;
      for (var i = 0; i < d.length; i++) {
         d[i][0] = 3;
         if (d[i][1] == 0) { d[i][1] = 15000; }
      }
      _root.__mod.flush();
      _root.__mod.msg = "Meydan okumalar 3 yıldız!";
   };

   // ---------- sekme icerikleri ----------
   M.items = new Array();
   M.items[0] = [
      {t:"tog", k:"god", l:"Ölümsüzlük (Tanrı Modu)"},
      {t:"tog", k:"lives", l:"Sonsuz Can"},
      {t:"tog", k:"ammo", l:"Sonsuz Mermi"},
      {t:"tog", k:"nades", l:"Sonsuz El Bombası"},
      {t:"tog", k:"rapid", l:"Seri Atış (Rapid Fire)"},
      {t:"tog", k:"norecoil", l:"Geri Tepme Yok"},
      {t:"tog", k:"ijump", l:"Sonsuz Zıplama"},
      {t:"tog", k:"tjump", l:"Üçlü Zıplama"},
      {t:"tog", k:"jet", l:"Sonsuz Jetpack"},
      {t:"tog", k:"fly", l:"Uçma Modu (Yukarı/Aşağı)"},
      {t:"tog", k:"speedb", l:"Sürekli Hız Güçlendirici"},
      {t:"tog", k:"invis", l:"Görünmezlik"},
      {t:"tog", k:"mini", l:"Mini Mod"},
      {t:"num", n:"spd", l:"Hız Çarpanı"},
      {t:"btn", f:"lives10", l:"+10 Can Ver"},
      {t:"btn", f:"center", l:"Haritanın Ortasına Işınlan"}
   ];
   M.items[1] = [
      {t:"num", n:"gun", l:"Seçili Silah"},
      {t:"num", n:"gun10", l:"Hızlı Gezin"},
      {t:"btn", f:"equip", l:"Seçili Silahı AL (Ben)"},
      {t:"btn", f:"nextgun", l:"Sonraki Silahı AL"},
      {t:"btn", f:"randgun", l:"Rastgele Güçlü Silah AL"},
      {t:"btn", f:"equipbots", l:"Seçili Silahı Botlara Ver"},
      {t:"btn", f:"botrand", l:"Botlara Rastgele Silah"}
   ];
   M.items[2] = [
      {t:"num", n:"grav", l:"Yerçekimi"},
      {t:"num", n:"jump", l:"Zıplama Gücü"},
      {t:"num", n:"fric", l:"Zemin Sürtünmesi"},
      {t:"tog", k:"pause", l:"Oyunu Duraklat"},
      {t:"tog", k:"cstorm", l:"Sandık Yağmuru"},
      {t:"tog", k:"pstorm", l:"Güçlendirici Yağmuru"},
      {t:"btn", f:"crate", l:"Sandık Çıkar"},
      {t:"btn", f:"crate10", l:"10 Sandık Çıkar"},
      {t:"btn", f:"powerup", l:"Güçlendirici Çıkar"},
      {t:"btn", f:"powerup7", l:"7 Güçlendirici Çıkar"}
   ];
   M.items[3] = [
      {t:"btn", f:"killbots", l:"Tüm Botları Öldür"},
      {t:"btn", f:"elimbots", l:"Tüm Botları Ele (Can Sıfır)"},
      {t:"btn", f:"botlife1", l:"Botların Canını 1 Yap"},
      {t:"btn", f:"bring", l:"Botları Bana Işınla"},
      {t:"tog", k:"botfreeze", l:"Botları Dondur"},
      {t:"tog", k:"botdisarm", l:"Botları Silahsızlandır"},
      {t:"tog", k:"botslow", l:"Botları Yavaşlat"},
      {t:"tog", k:"botloop", l:"Bot Avı (Sürekli Öldür)"}
   ];
   M.items[4] = [
      {t:"btn", f:"unlockm", l:"Tüm Görevleri Aç"},
      {t:"btn", f:"completem", l:"Tüm Görevleri Tamamla"},
      {t:"btn", f:"challenges", l:"Meydan Okumalar: 3 Yıldız"}
   ];

   // ---------- arayuz cizimi ----------
   M.build = function() {
      var m = _root.__mod;
      m.mc.body.removeMovieClip();
      var body = m.mc.createEmptyMovieClip("body", 10);
      var its = m.items[m.tab];
      var y = 66;
      for (var i = 0; i < its.length; i++) {
         var it = its[i];
         var r = body.createEmptyMovieClip("r" + i, i + 1);
         r._x = 600;
         r._y = y;
         m.rect(r, 0, 0, 280, 25, 0x1c1c2e, 90);
         m.txt(r, "lb", 1, 6, 4, 190, 20, it.l, 12, 0xE8E8FF, false, "left");
         if (it.t == "tog") {
            var onn = m.on[it.k];
            var bt = r.createEmptyMovieClip("bt", 2);
            m.rect(bt, 0, 0, 66, 19, onn ? 0x22cc66 : 0x aa2233, 100);
            m.txt(bt, "tx", 1, 0, 2, 66, 16, onn ? "AÇIK" : "KAPALI", 11, 0xFFFFFF, true, "center");
            bt._x = 208;
            bt._y = 3;
            r.k = it.k;
            r.onRelease = function() {
               var mm = _root.__mod;
               mm.on[this.k] = !mm.on[this.k];
               mm.build();
            };
         } else if (it.t == "btn") {
            var bt2 = r.createEmptyMovieClip("bt", 2);
            m.rect(bt2, 0, 0, 66, 19, 0x7a2cff, 100);
            m.txt(bt2, "tx", 1, 0, 2, 66, 16, "UYGULA", 11, 0xFFFFFF, true, "center");
            bt2._x = 208;
            bt2._y = 3;
            r.f = it.f;
            r.onRelease = function() {
               var mm = _root.__mod;
               mm["f_" + this.f]();
               mm.build();
            };
         } else {
            m.txt(r, "vl", 3, 120, 4, 88, 20, m["g_" + it.n](), 12, 0xFFE14D, true, "center");
            var mi = r.createEmptyMovieClip("mi", 4);
            m.rect(mi, 0, 0, 30, 19, 0x444466, 100);
            m.txt(mi, "tx", 1, 0, 1, 30, 18, "-", 14, 0xFFFFFF, true, "center");
            mi._x = 205;
            mi._y = 3;
            mi.n = it.n;
            mi.d = -1;
            mi.onRelease = function() {
               var mm = _root.__mod;
               mm["s_" + this.n](this.d);
               mm.build();
            };
            var pl = r.createEmptyMovieClip("pl", 5);
            m.rect(pl, 0, 0, 30, 19, 0x444466, 100);
            m.txt(pl, "tx", 1, 0, 1, 30, 18, "+", 14, 0xFFFFFF, true, "center");
            pl._x = 243;
            pl._y = 3;
            pl.n = it.n;
            pl.d = 1;
            pl.onRelease = function() {
               var mm = _root.__mod;
               mm["s_" + this.n](this.d);
               mm.build();
            };
         }
         y += 28;
      }
      m.mc.stat.text = (m.msg != undefined) ? m.msg : "";
      m.msg = undefined;
   };

   M.makeUI = function() {
      var m = _root.__mod;
      var mc = _root.createEmptyMovieClip("modmenu", 15000);
      m.mc = mc;
      var bg = mc.createEmptyMovieClip("bg", 1);
      m.rect(bg, 590, 6, 302, 588, 0x0a0a14, 92);
      m.rect(bg, 590, 6, 302, 34, 0x7a2cff, 100);
      m.txt(mc, "title", 2, 590, 11, 302, 26, "★ MOD MENÜSÜ ★", 18, 0xFFFFFF, true, "center");
      var tw = 302 / 5;
      for (var i = 0; i < 5; i++) {
         var tb = mc.createEmptyMovieClip("tab" + i, 3 + i);
         m.rect(tb, 0, 0, tw - 2, 20, (i == m.tab) ? 0xFFE14D : 0x2a2a44, 100);
         m.txt(tb, "tx", 1, 0, 2, tw - 2, 18, m.tabs[i], 10, (i == m.tab) ? 0x000000 : 0xFFFFFF, true, "center");
         tb._x = 591 + i * tw;
         tb._y = 42;
         tb.i = i;
         tb.onRelease = function() {
            var mm = _root.__mod;
            mm.tab = this.i;
            mm.makeUI();
         };
      }
      m.txt(mc, "stat", 20, 596, 566, 290, 16, "", 11, 0x7CFF9E, true, "center");
      m.txt(mc, "foot", 21, 590, 578, 302, 16, "INSERT veya ` : menüyü aç / kapat", 10, 0x8888AA, false, "center");
      m.build();
      mc._visible = m.open;
   };

   M.toggle = function() {
      var m = _root.__mod;
      m.open = !m.open;
      m.mc._visible = m.open;
      if (m.open) { Mouse.show(); }
   };

   // ---------- ana dongu: hileleri uygula ----------
   M.tick = function() {
      var m = _root.__mod;
      m.mc._x = -_root._x;
      m.mc._y = -_root._y;
      m.hint._alpha = (m.fc < 280) ? 100 : 40;
      m.fc++;
      var on = m.on;
      var a = _root.activeplayers;
      var i;
      var p;
      if (a != undefined) {
         for (i = 0; i < a.length; i++) {
            p = a[i];
            if (p == undefined || p.iszombie) { continue; }
            if (p.AI) {
               if (on.botfreeze) {
                  if (p.mfx == undefined) { p.mfx = p._x; p.mfy = p._y; }
                  p._x = p.mfx;
                  p._y = p.mfy;
                  p.vx = 0;
                  p.vy = 0;
               } else {
                  p.mfx = undefined;
               }
               if (on.botdisarm) { p.waittime = -99999; }
               if (on.botslow) { p.vx *= 0.8; }
            } else if (p.lives > 0) {
               if (on.god) {
                  p.shieldtime = 300;
                  if (p._y > 850 || p._x < -450 || p._x > 1350) {
                     p._x = _root.ground._x + _root.ground.spawnarea._x + random(_root.ground.spawnarea._width);
                     p._y = -300;
                     p.vx = 0;
                     p.vy = 0;
                  }
               }
               if (on.lives && p.lives < 99) { p.lives = 99; }
               if (on.ammo) { p.bullets = 9999; }
               if (on.nades && p.offhandammo < 99) { p.offhandammo = 99; }
               if (on.rapid) { p.rof = 2; }
               if (on.norecoil) { p.recoil = 0; p.pushback = 0; }
               if (on.ijump && p.jumpnum < 1) { p.jumpnum = 1; }
               if (on.tjump) { p.triplejump = true; }
               if (on.jet) { p.jetfuel = 100; }
               if (on.speedb) { p.speedtime = 300; }
               if (on.invis) { p.invisibletime = 200; }
               if (on.mini && p.minitime < 100) { p.minitime = 400; }
               if (on.fly) {
                  if (Key.isDown(p.KEYUP)) { p.vy = -9; }
                  else if (Key.isDown(p.KEYDOWN)) { p.vy = 9; }
                  else { p.vy = 0; }
               }
               if (m.spd > 1) {
                  var ax = _root.speed * (m.spd - 1);
                  if (Key.isDown(p.KEYLEFT)) { p.vx -= ax; }
                  if (Key.isDown(p.KEYRIGHT)) { p.vx += ax; }
               }
            }
         }
      }
      if (on.pause) {
         _root.gamepaused = true;
         m.paused = true;
      } else if (m.paused) {
         _root.gamepaused = false;
         m.paused = false;
      }
      if (on.cstorm && m.fc % 12 == 0) { m.f_crate(); }
      if (on.pstorm && m.fc % 25 == 0) { m.f_powerup(); }
      if (on.botloop && m.fc % 40 == 0) {
         var bb = m.bots();
         if (bb.length > 0) { bb[random(bb.length)].gotkilled(); }
      }
   };

   M.makeUI();
   M.hint = _root.createEmptyMovieClip("modhint", 15001);
   M.txt(M.hint, "t", 1, 8, 578, 260, 18, "MOD: INSERT veya ` tuşu", 11, 0x7CFF9E, true, "left");
   M.hint.onEnterFrame = M.tick;

   M.kl = new Object();
   M.kl.onKeyDown = function() {
      var c = Key.getCode();
      if (c == 45 || c == 192) { _root.__mod.toggle(); }
   };
   Key.addListener(M.kl);
}
