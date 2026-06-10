/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { SingletonHelper } from '@ohos/basicutils';

const TAG = 'GestureDockModeSortManager';

class HanZiAndPinYin {
  public key: string = '';
  public pinyin: string = '';
}

const HANZI_TO_PINYIN: HanZiAndPinYin[] = [
  { key: '阿', pinyin: 'a' }, { key: '哎', pinyin: 'ai' }, { key: '安', pinyin: 'an' },
  { key: '肮', pinyin: 'ang' }, { key: '凹', pinyin: 'ao' }, { key: '丷', pinyin: 'ba' },
  { key: '挀', pinyin: 'bai' }, { key: '扳', pinyin: 'ban' }, { key: '邦', pinyin: 'bang' },
  { key: '勹', pinyin: 'bao' }, { key: '陂', pinyin: 'bei' }, { key: '奔', pinyin: 'ben' },
  { key: '伻', pinyin: 'beng' }, { key: '屄', pinyin: 'bi' }, { key: '边', pinyin: 'bian' },
  { key: '灬', pinyin: 'biao' }, { key: '憋', pinyin: 'bie' }, { key: '汃', pinyin: 'bin' },
  { key: '冫', pinyin: 'bing' }, { key: '癶', pinyin: 'bo' }, { key: '峬', pinyin: 'bu' },
  { key: '嚓', pinyin: 'ca' }, { key: '偲', pinyin: 'cai' }, { key: '参', pinyin: 'can' },
  { key: '仓', pinyin: 'cang' }, { key: '撡', pinyin: 'cao' }, { key: '冊', pinyin: 'ce' },
  { key: '嵾', pinyin: 'cen' }, { key: '曽', pinyin: 'ceng' }, { key: '叉', pinyin: 'cha' },
  { key: '芆', pinyin: 'chai' }, { key: '辿', pinyin: 'chan' }, { key: '伥', pinyin: 'chang' },
  { key: '抄', pinyin: 'chao' }, { key: '车', pinyin: 'che' }, { key: '抻', pinyin: 'chen' },
  { key: '阷', pinyin: 'cheng' }, { key: '吃', pinyin: 'chi' }, { key: '充', pinyin: 'chong' },
  { key: '抽', pinyin: 'chou' }, { key: '出', pinyin: 'chu' }, { key: '欻', pinyin: 'chua' },
  { key: '揣', pinyin: 'chuai' }, { key: '巛', pinyin: 'chuan' }, { key: '刅', pinyin: 'chuang' },
  { key: '吹', pinyin: 'chui' }, { key: '旾', pinyin: 'chun' }, { key: '逴', pinyin: 'chuo' },
  { key: '呲', pinyin: 'ci' }, { key: '匆', pinyin: 'cong' }, { key: '凑', pinyin: 'cou' },
  { key: '粗', pinyin: 'cu' }, { key: '汆', pinyin: 'cuan' }, { key: '崔', pinyin: 'cui' },
  { key: '邨', pinyin: 'cun' }, { key: '搓', pinyin: 'cuo' }, { key: '咑', pinyin: 'da' },
  { key: '呆', pinyin: 'dai' }, { key: '丹', pinyin: 'dan' }, { key: '当', pinyin: 'dang' },
  { key: '刀', pinyin: 'dao' }, { key: '嘚', pinyin: 'de' }, { key: '扥', pinyin: 'dun' },
  { key: '灯', pinyin: 'deng' }, { key: '氐', pinyin: 'di' }, { key: '甸', pinyin: 'dian' },
  { key: '刁', pinyin: 'diao' }, { key: '爹', pinyin: 'die' }, { key: '丁', pinyin: 'ding' },
  { key: '丟', pinyin: 'diu' }, { key: '东', pinyin: 'dong' }, { key: '吺', pinyin: 'dou' },
  { key: '厾', pinyin: 'du' }, { key: '耑', pinyin: 'duan' }, { key: '垖', pinyin: 'dui' },
  { key: '吨', pinyin: 'dun' }, { key: '多', pinyin: 'duo' }, { key: '妸', pinyin: 'e' },
  { key: '诶', pinyin: 'ei' }, { key: '奀', pinyin: 'en' }, { key: '鞥', pinyin: 'eng' },
  { key: '儿', pinyin: 'er' }, { key: '发', pinyin: 'fa' }, { key: '帆', pinyin: 'fan' },
  { key: '匚', pinyin: 'fang' }, { key: '飞', pinyin: 'fei' }, { key: '分', pinyin: 'fen' },
  { key: '丰', pinyin: 'feng' }, { key: '覅', pinyin: 'fiao' }, { key: '仏', pinyin: 'fo' },
  { key: '紑', pinyin: 'fou' }, { key: '夫', pinyin: 'fu' }, { key: '旮', pinyin: 'ga' },
  { key: '侅', pinyin: 'gai' }, { key: '甘', pinyin: 'gan' }, { key: '冈', pinyin: 'gang' },
  { key: '皋', pinyin: 'gao' }, { key: '戈', pinyin: 'ge' }, { key: '给', pinyin: 'gei' },
  { key: '根', pinyin: 'gen' }, { key: '刯', pinyin: 'geng' }, { key: '工', pinyin: 'gong' },
  { key: '勾', pinyin: 'gou' }, { key: '估', pinyin: 'gu' }, { key: '瓜', pinyin: 'gua' },
  { key: '乖', pinyin: 'guai' }, { key: '关', pinyin: 'guan' }, { key: '光', pinyin: 'guang' },
  { key: '归', pinyin: 'gui' }, { key: '丨', pinyin: 'gun' }, { key: '呙', pinyin: 'guo' },
  { key: '哈', pinyin: 'ha' }, { key: '咍', pinyin: 'hai' }, { key: '佄', pinyin: 'han' },
  { key: '夯', pinyin: 'hang' }, { key: '茠', pinyin: 'hao' }, { key: '诃', pinyin: 'he' },
  { key: '黒', pinyin: 'hei' }, { key: '拫', pinyin: 'hen' }, { key: '亨', pinyin: 'heng' },
  { key: '噷', pinyin: 'hm' }, { key: '叿', pinyin: 'hong' }, { key: '齁', pinyin: 'hou' },
  { key: '乎', pinyin: 'hu' }, { key: '花', pinyin: 'hua' }, { key: '怀', pinyin: 'huai' },
  { key: '欢', pinyin: 'huan' }, { key: '巟', pinyin: 'huang' }, { key: '灰', pinyin: 'hui' },
  { key: '昏', pinyin: 'hun' }, { key: '吙', pinyin: 'huo' }, { key: '丌', pinyin: 'ji' },
  { key: '加', pinyin: 'jia' }, { key: '戋', pinyin: 'jian' }, { key: '江', pinyin: 'jiang' },
  { key: '艽', pinyin: 'jiao' }, { key: '阶', pinyin: 'jie' }, { key: '巾', pinyin: 'jin' },
  { key: '坕', pinyin: 'jing' }, { key: '冂', pinyin: 'jiong' }, { key: '丩', pinyin: 'jiu' },
  { key: '凥', pinyin: 'ju' }, { key: '姢', pinyin: 'juan' }, { key: '噘', pinyin: 'jue' },
  { key: '军', pinyin: 'jun' }, { key: '咔', pinyin: 'ka' }, { key: '开', pinyin: 'kai' },
  { key: '刊', pinyin: 'kan' }, { key: '忼', pinyin: 'kang' }, { key: '尻', pinyin: 'kao' },
  { key: '匼', pinyin: 'ke' }, { key: '肎', pinyin: 'ken' }, { key: '劥', pinyin: 'keng' },
  { key: '空', pinyin: 'kong' }, { key: '抠', pinyin: 'kou' }, { key: '扝', pinyin: 'ku' },
  { key: '夸', pinyin: 'kua' }, { key: '蒯', pinyin: 'kuai' }, { key: '宽', pinyin: 'kuan' },
  { key: '匡', pinyin: 'kuang' }, { key: '亏', pinyin: 'kui' }, { key: '坤', pinyin: 'kun' },
  { key: '扩', pinyin: 'kuo' }, { key: '垃', pinyin: 'la' }, { key: '来', pinyin: 'lai' },
  { key: '兰', pinyin: 'lan' }, { key: '啷', pinyin: 'lang' }, { key: '捞', pinyin: 'lao' },
  { key: '肋', pinyin: 'le' }, { key: '勒', pinyin: 'lei' }, { key: '崚', pinyin: 'leng' },
  { key: '哩', pinyin: 'li' }, { key: '俩', pinyin: 'lia' }, { key: '奁', pinyin: 'lian' },
  { key: '良', pinyin: 'liang' }, { key: '撩', pinyin: 'liao' }, { key: '毟', pinyin: 'lie' },
  { key: '拎', pinyin: 'lin' }, { key: '伶', pinyin: 'ling' }, { key: '溜', pinyin: 'liu' },
  { key: '囖', pinyin: 'lo' }, { key: '龙', pinyin: 'long' }, { key: '瞜', pinyin: 'lou' },
  { key: '噜', pinyin: 'lu' }, { key: '驴', pinyin: 'lv' }, { key: '娈', pinyin: 'luan' },
  { key: '掠', pinyin: 'lüe' }, { key: '抡', pinyin: 'lun' }, { key: '罗', pinyin: 'luo' },
  { key: '呣', pinyin: 'm' }, { key: '妈', pinyin: 'ma' }, { key: '埋', pinyin: 'mai' },
  { key: '嫚', pinyin: 'man' }, { key: '牤', pinyin: 'mang' }, { key: '猫', pinyin: 'mao' },
  { key: '嚒', pinyin: 'me' }, { key: '呅', pinyin: 'mei' }, { key: '椚', pinyin: 'men' },
  { key: '擝', pinyin: 'meng' }, { key: '咪', pinyin: 'mi' }, { key: '宀', pinyin: 'mian' },
  { key: '喵', pinyin: 'miao' }, { key: '乜', pinyin: 'mie' }, { key: '民', pinyin: 'min' },
  { key: '名', pinyin: 'ming' }, { key: '谬', pinyin: 'miu' }, { key: '摸', pinyin: 'mo' },
  { key: '哞', pinyin: 'mou' }, { key: '毪', pinyin: 'mu' }, { key: '拏', pinyin: 'na' },
  { key: '腉', pinyin: 'nai' }, { key: '囡', pinyin: 'nan' }, { key: '囔', pinyin: 'nang' },
  { key: '孬', pinyin: 'nao' }, { key: '疒', pinyin: 'ne' }, { key: '娞', pinyin: 'nei' },
  { key: '恁', pinyin: 'nen' }, { key: '能', pinyin: 'neng' }, { key: '妮', pinyin: 'ni' },
  { key: '拈', pinyin: 'nian' }, { key: '娘', pinyin: 'niang' }, { key: '鸟', pinyin: 'niao' },
  { key: '捏', pinyin: 'nie' }, { key: '囜', pinyin: 'nin' }, { key: '宁', pinyin: 'ning' },
  { key: '妞', pinyin: 'niu' }, { key: '农', pinyin: 'nong' }, { key: '羺', pinyin: 'nou' },
  { key: '奴', pinyin: 'nu' }, { key: '女', pinyin: 'nv' }, { key: '奻', pinyin: 'nuan' },
  { key: '疟', pinyin: 'nüe' }, { key: '黁', pinyin: 'nun' }, { key: '挪', pinyin: 'nuo' },
  { key: '喔', pinyin: 'o' }, { key: '讴', pinyin: 'ou' }, { key: '妑', pinyin: 'pa' },
  { key: '拍', pinyin: 'pai' }, { key: '眅', pinyin: 'pan' }, { key: '乓', pinyin: 'pang' },
  { key: '抛', pinyin: 'pao' }, { key: '呸', pinyin: 'pei' }, { key: '喷', pinyin: 'pen' },
  { key: '匉', pinyin: 'peng' }, { key: '丕', pinyin: 'pi' }, { key: '囨', pinyin: 'pian' },
  { key: '剽', pinyin: 'piao' }, { key: '氕', pinyin: 'pie' }, { key: '姘', pinyin: 'pin' },
  { key: '乒', pinyin: 'ping' }, { key: '钋', pinyin: 'po' }, { key: '剖', pinyin: 'pou' },
  { key: '仆', pinyin: 'pu' }, { key: '七', pinyin: 'qi' }, { key: '掐', pinyin: 'qia' },
  { key: '千', pinyin: 'qian' }, { key: '呛', pinyin: 'qiang' }, { key: '悄', pinyin: 'qiao' },
  { key: '苆', pinyin: 'qie' }, { key: '亲', pinyin: 'qin' }, { key: '靑', pinyin: 'qing' },
  { key: '卭', pinyin: 'qiong' }, { key: '丘', pinyin: 'qiu' }, { key: '区', pinyin: 'qu' },
  { key: '奍', pinyin: 'quan' }, { key: '缺', pinyin: 'que' }, { key: '夋', pinyin: 'qun' },
  { key: '呥', pinyin: 'ran' }, { key: '穣', pinyin: 'rang' }, { key: '娆', pinyin: 'rao' },
  { key: '惹', pinyin: 're' }, { key: '人', pinyin: 'ren' }, { key: '扔', pinyin: 'reng' },
  { key: '日', pinyin: 'ri' }, { key: '茸', pinyin: 'rong' }, { key: '厹', pinyin: 'rou' },
  { key: '邚', pinyin: 'ru' }, { key: '挼', pinyin: 'rua' }, { key: '堧', pinyin: 'ruan' },
  { key: '婑', pinyin: 'rui' }, { key: '瞤', pinyin: 'run' }, { key: '捼', pinyin: 'ruo' },
  { key: '仨', pinyin: 'sa' }, { key: '毢', pinyin: 'sai' }, { key: '三', pinyin: 'san' },
  { key: '桒', pinyin: 'sang' }, { key: '掻', pinyin: 'sao' }, { key: '閪', pinyin: 'se' },
  { key: '森', pinyin: 'sen' }, { key: '僧', pinyin: 'seng' }, { key: '杀', pinyin: 'sha' },
  { key: '筛', pinyin: 'shai' }, { key: '山', pinyin: 'shan' }, { key: '伤', pinyin: 'shang' },
  { key: '弰', pinyin: 'shao' }, { key: '奢', pinyin: 'she' }, { key: '申', pinyin: 'shen' },
  { key: '升', pinyin: 'sheng' }, { key: '尸', pinyin: 'shi' }, { key: '収', pinyin: 'shou' },
  { key: '书', pinyin: 'shu' }, { key: '刷', pinyin: 'shua' }, { key: '衰', pinyin: 'shuai' },
  { key: '闩', pinyin: 'shuan' }, { key: '双', pinyin: 'shuang' }, { key: '脽', pinyin: 'shui' },
  { key: '吮', pinyin: 'shun' }, { key: '说', pinyin: 'shuo' }, { key: '厶', pinyin: 'si' },
  { key: '忪', pinyin: 'song' }, { key: '凁', pinyin: 'sou' }, { key: '苏', pinyin: 'su' },
  { key: '狻', pinyin: 'suan' }, { key: '夊', pinyin: 'sui' }, { key: '孙', pinyin: 'sun' },
  { key: '唆', pinyin: 'suo' }, { key: '他', pinyin: 'ta' }, { key: '囼', pinyin: 'tai' },
  { key: '坍', pinyin: 'tan' }, { key: '汤', pinyin: 'tang' }, { key: '夲', pinyin: 'tao' },
  { key: '忑', pinyin: 'te' }, { key: '熥', pinyin: 'teng' }, { key: '剔', pinyin: 'ti' },
  { key: '天', pinyin: 'tian' }, { key: '旫', pinyin: 'tiao' }, { key: '帖', pinyin: 'tie' },
  { key: '厅', pinyin: 'ting' }, { key: '囲', pinyin: 'tong' }, { key: '偷', pinyin: 'tou' },
  { key: '凸', pinyin: 'tu' }, { key: '湍', pinyin: 'tuan' }, { key: '推', pinyin: 'tui' },
  { key: '吞', pinyin: 'tun' }, { key: '乇', pinyin: 'tuo' }, { key: '屲', pinyin: 'wa' },
  { key: '歪', pinyin: 'wai' }, { key: '弯', pinyin: 'wan' }, { key: '尣', pinyin: 'wang' },
  { key: '危', pinyin: 'wei' }, { key: '昷', pinyin: 'wen' }, { key: '翁', pinyin: 'weng' },
  { key: '挝', pinyin: 'wo' }, { key: '乌', pinyin: 'wu' }, { key: '夕', pinyin: 'xi' },
  { key: '虲', pinyin: 'xia' }, { key: '仙', pinyin: 'xian' }, { key: '乡', pinyin: 'xiang' },
  { key: '灱', pinyin: 'xiao' }, { key: '些', pinyin: 'xie' }, { key: '心', pinyin: 'xin' },
  { key: '星', pinyin: 'xing' }, { key: '凶', pinyin: 'xiong' }, { key: '休', pinyin: 'xiu' },
  { key: '吁', pinyin: 'xu' }, { key: '吅', pinyin: 'xuan' }, { key: '削', pinyin: 'xue' },
  { key: '坃', pinyin: 'xun' }, { key: '丫', pinyin: 'ya' }, { key: '恹', pinyin: 'yan' },
  { key: '央', pinyin: 'yang' }, { key: '幺', pinyin: 'yao' }, { key: '倻', pinyin: 'ye' },
  { key: '一', pinyin: 'yi' }, { key: '囙', pinyin: 'yin' }, { key: '应', pinyin: 'ying' },
  { key: '哟', pinyin: 'yo' }, { key: '佣', pinyin: 'yong' }, { key: '优', pinyin: 'you' },
  { key: '込', pinyin: 'yu' }, { key: '囦', pinyin: 'yuan' }, { key: '曰', pinyin: 'yue' },
  { key: '晕', pinyin: 'yun' }, { key: '帀', pinyin: 'za' }, { key: '災', pinyin: 'zai' },
  { key: '兂', pinyin: 'zan' }, { key: '匨', pinyin: 'zang' }, { key: '傮', pinyin: 'zao' },
  { key: '则', pinyin: 'ze' }, { key: '贼', pinyin: 'zei' }, { key: '怎', pinyin: 'zen' },
  { key: '増', pinyin: 'zeng' }, { key: '扎', pinyin: 'zha' }, { key: '夈', pinyin: 'zhai' },
  { key: '枬', pinyin: 'zhan' }, { key: '张', pinyin: 'zhang' }, { key: '佋', pinyin: 'zhao' },
  { key: '蜇', pinyin: 'zhe' }, { key: '贞', pinyin: 'zhen' }, { key: '凧', pinyin: 'zheng' },
  { key: '之', pinyin: 'zhi' }, { key: '中', pinyin: 'zhong' }, { key: '州', pinyin: 'zhou' },
  { key: '朱', pinyin: 'zhu' }, { key: '抓', pinyin: 'zhua' }, { key: '拽', pinyin: 'zhuai' },
  { key: '专', pinyin: 'zhuan' }, { key: '妆', pinyin: 'zhuang' }, { key: '隹', pinyin: 'zhui' },
  { key: '宒', pinyin: 'zhun' }, { key: '卓', pinyin: 'zhuo' }, { key: '乲', pinyin: 'zi' },
  { key: '宗', pinyin: 'zong' }, { key: '邹', pinyin: 'zou' }, { key: '租', pinyin: 'zu' },
  { key: '钻', pinyin: 'zuan' }, { key: '厜', pinyin: 'zui' }, { key: '尊', pinyin: 'zun' },
  { key: '昨', pinyin: 'zuo' }
];

/**
 * 在已排序数组中查找第一个严格大于 target 的元素（上界）
 * @param sortedArray 已排序的数组
 * @param target 目标值
 * @param compareFn 自定义比较函数，默认按升序排序
 * @returns 上界元素的索引，若不存在返回数组长度
 */
export function upperBound<T, T2 = T>(
  sortedArray: T[],
  target: T2,
  compareFn: (a: T, b: T2) => number,
  leftIndex?: number,
  rightIndex?: number
): number {
  let left = leftIndex ?? 0;
  let right = rightIndex ?? sortedArray.length;

  while (left < right) {
    const mid = Math.floor((left + right) / 2);
    if (compareFn(sortedArray[mid], target) <= 0) {
      left = mid + 1;
    } else {
      right = mid;
    }
  }

  return left;
}


export class GestureDockModeSortManager {
  private collator = new Intl.Collator('zh-CN'); // 使用中文排序规则
  private static instance: GestureDockModeSortManager;

  public static getInstance(): GestureDockModeSortManager {
    if (!GestureDockModeSortManager.instance) {
      GestureDockModeSortManager.instance = new GestureDockModeSortManager();
    }
    return GestureDockModeSortManager.instance;
  }

  public getIndexer(str: string): string {
    if (str.length === 0) {
      return '#';
    }
    const ch = str.charAt(0);
    if (this.isAlphaIndexer(ch)) {
      return ch.toUpperCase();
    }
    if (!this.isHanZi(ch)) {
      return '#';
    }
    return this.getHanZiIndexer(str);
  }

  public isAlphaIndexer(ch: string): boolean {
    const code = ch.charCodeAt(0);
    // 大写字母A-Z: 65-90
    // 小写字母a-z: 97-122
    return (code >= 65 && code <= 90) || (code >= 97 && code <= 122);
  }

  public isHanZi(ch: string): boolean {
    const code = ch.charCodeAt(0);
    return code >= 0x4E00 && code <= 0x9FA5;
  }

  public getHanZiIndexer(str: string): string {
    const index = upperBound(HANZI_TO_PINYIN, str, (hanZiPinYin: HanZiAndPinYin, strb: string): number => {
      return this.collator.compare(hanZiPinYin.key, strb);
    });
    if (index === 0) {
      return 'A';
    }
    return HANZI_TO_PINYIN[index - 1].pinyin.charAt(0).toUpperCase();
  }

  public hasValidIndexer(str: string): boolean {
    return (str.length !== 0) && (this.isAlphaIndexer(str) || this.isHanZi(str));
  }

  public compare(str1: string, str2: string): number {
    const isValidIndex1 = this.hasValidIndexer(str1);
    const isValidIndex2 = this.hasValidIndexer(str2);
    if (!isValidIndex1 && isValidIndex2) {
      return -1;
    }
    if (isValidIndex1 && !isValidIndex2) {
      return 1;
    }
    if (!isValidIndex1 && !isValidIndex2) {
      return this.collator.compare(str1, str2);
    }
    const isAlpha1 = this.isAlphaIndexer(str1);
    const isAlpha2 = this.isAlphaIndexer(str2);
    if (isAlpha1 && isAlpha2) {
      return this.collator.compare(str1, str2);
    }
    if ((isAlpha1 && !isAlpha2) || (!isAlpha1 && isAlpha2)) {
      const indexer1 = this.getIndexer(str1);
      const indexer2 = this.getIndexer(str2);
      if (indexer1 === indexer2) {
        return isAlpha1 ? -1 : 1;
      }
      return indexer1 < indexer2 ? -1 : 1;
    }
    return this.collator.compare(str1, str2);
  }
}

