/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { HashMap } from '@kit.ArkTS';
import { image } from '@kit.ImageKit';
import { CompanionIconInfo, LogDomain, LogHelper, RectInfo } from '@ohos/basicutils';

const TAG = 'IntelligentCache';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AA, TAG);

/**
 * 动效回调
 */
type OnAnimIntelligent = (needAnimate?: boolean) => void;

export class IntelligentCache {
  private static sInstance: IntelligentCache;
  // 负一屏头像IconId
  public static readonly MY_PAGE_ICON_ID: string = 'Intelligent_Me_12345';
  // 负一屏服务动态兜底图IconId
  public static readonly STATE_MACHINE_DEFAULT_ICON_ID: string = 'Intelligent_StateMachine_Default';
  // 负一屏服务动态IconId 前缀
  public static readonly STATE_MACHINE_ICON_ID: string = 'Intelligent_StateMachine_';
  // 负一屏FaIconId 前缀
  public static readonly OTHER_PAGE_ICON_ID: string = 'Intelligent_Other';
  // 负一屏FaIconId 前缀
  public static readonly INTELLIGENT_FA_PREFIX: string = 'Intelligent_FA_';
  // 负一屏最近使用IconId 前缀
  public static readonly INTELLIGENT_RECENTLY_USE_PREFIX: string = 'Intelligent_RecentlyUse_';
  // 涉及负一屏IconId 前缀
  public static readonly INTELLIGENT_PREFIX: string = 'Intelligent_';
  // 负一屏资讯IconId
  public static readonly FEED_DEFAULT_ICON_ID: string = 'Intelligent_Feed_Default';
  // 负一屏搜索页面
  public static readonly INTELLIGENT_SEARCH_PAGE = 'searchPage';
  // 负一屏服务动态卡片堆叠态IconId 前缀
  public static readonly STATE_MACHINE_CARDSTACK_ICON_ID: string = 'Intelligent_StateMachine_CardStack';
  // 负一屏服务动态卡片展开态IconId 前缀
  public static readonly STATE_MACHINE_CARDSTACKEXPAND_ICON_ID: string = 'Intelligent_StateMachine_CardStackExpand';
  // 负一屏首页扫一扫
  public static readonly INTELLIGENT_HEADERAREA_SCANBUTTON_ID: string = 'Intelligent_HeaderArea_ScanButton';
  // 负一屏精选服务 更多
  public static readonly INTELLIGENT_GRIDSERVICE_CLICKMORE_ID: string = 'Intelligent_GridService_ClickMore';
  // 负一屏服务工具前缀
  public static readonly INTELLIGENT_TOOLSERVICE_PREFIX: string = 'Intelligent_ToolService_';

  public static readonly INTELLIGENT_BUNDLE: string = 'com.ohos.intelligent';
  private iconCacheMap: HashMap<string, image.PixelMap> = new HashMap();
  private iconIdCache: HashMap<string, string> = new HashMap();
  private stateMachineIconIdSet: Set<string> = new Set();
  private appSwitch: boolean = true;
  private iconListenerMap: Map<string, Function> = new Map();
  private resetScroll?: Function;
  private getCardExpandOffsetY?: Function;

  private intelligentLaunchPage: string = '';

  private animOpen: OnAnimIntelligent | undefined = undefined;

  private animClose: OnAnimIntelligent | undefined = undefined;

  private doAnimFlag: boolean = false;
  private calculateNegativeRectFun?: Function;

  /**
   * 获取实例
   */
  static getInstance(): IntelligentCache {
    if (!IntelligentCache.sInstance) {
      IntelligentCache.sInstance = new IntelligentCache();
    }
    return IntelligentCache.sInstance;
  }

  public setIntelligentLaunchPage(intelligentLaunchPage: string): void {
    if (intelligentLaunchPage === IntelligentCache.INTELLIGENT_SEARCH_PAGE) {
      this.doAnimFlag = true;
    }
    this.intelligentLaunchPage = intelligentLaunchPage;
  }

  public getIntelligentLaunchPage(): string {
    return this.intelligentLaunchPage;
  }

  public getDoAnimFlag(): boolean {
    return this.doAnimFlag;
  }

  public setDoAnimFlag(doAnimFlag: boolean): void {
    this.doAnimFlag = doAnimFlag;
    if (!doAnimFlag && this.animClose) {
      this.animClose(false);
    }
  }

  public setAnimOpen(animOpen?: OnAnimIntelligent): void {
    this.animOpen = animOpen;
  }

  public setAnimClose(animClose?: OnAnimIntelligent): void {
    this.animClose = animClose;
  }

  public doAnimOpen(): void {
    if (this.animOpen) {
      this.animOpen();
    }
  }

  public doAnimClose(): void {
    this.doAnimFlag = false;
    if (this.animClose) {
      this.animClose(true);
    }
  }

  /**
   * 添加动效icon监听
   */
  public addIconListener(iconId: string, listener: Function): void {
    if (!iconId || !listener) {
      return;
    }
    this.iconListenerMap.set(iconId, listener);
  }

  /**
   * 删除动效icon监听
   */
  public deleteIconListener(iconId: string): void {
    if (!iconId) {
      return;
    }
    this.iconListenerMap.delete(iconId);
  }

  /**
   * 深色模式触发icon监听
   */
  public darkModeChange(iconId: string): void {
    if (!iconId) {
      return;
    }
    let listener: Function | undefined = this.iconListenerMap.get(iconId);
    if (listener) {
      listener();
    }
  }

  /**
   * 设置重置Scroll回调
   */
  public setResetIntelligentScroll(resetScroll?: Function): void {
    this.resetScroll = resetScroll;
  }

  /**
   * 设置重置ScreenOffsetY回调
   */
  public setCardExpandViewScreenOffsetY(getCardExpandOffsetY?: Function): void {
    this.getCardExpandOffsetY = getCardExpandOffsetY;
  }

  /**
   * 执行ScreenOffsetY回调
   */
  public getCardExpandViewOffsetY(iconId: string): number {
    if (!this.getCardExpandOffsetY) {
      log.showInfo(`getCardExpandViewOffsetY, getCardExpandOffsetY is undefined`);
      return 0;
    }
    return this.getCardExpandOffsetY(iconId);
  }

  /**
   * 重置负一屏Scroll
   */
  public resetIntelligentScroll(): number {
    if (!this.resetScroll) {
      log.showInfo(`resetIntelligentScroll, resetScroll is undefined`);
      return 0;
    }
    return this.resetScroll();
  }

  /**
   * 将指定卡片id置入缓存
   * @param iconId 卡片id
   */
  public addIconById(iconId: string): void {
    if (!iconId) {
      log.showError(`addIconById, iconId is undefined`);
      return;
    }
    this.stateMachineIconIdSet.add(iconId);
  }

  /**
   * 将指定卡片id从缓存中移除
   * @param iconId 卡片id
   */
  public deleteIconById(iconId: string): void {
    if (!iconId) {
      log.showError(`deleteIconById, iconId is undefined`);
      return;
    }
    this.stateMachineIconIdSet.delete(iconId);
  }

  /**
   * 判断是否当前点击的负一屏ICON
   */
  public isCurrentIconId(bundleName: string, iconId: string): boolean {
    if (!iconId || !bundleName) {
      return false;
    }
    if (iconId.startsWith(IntelligentCache.STATE_MACHINE_ICON_ID) && this.stateMachineIconIdSet.has(iconId)) {
      return true;
    }
    log.showInfo(`isCurrentIconId bundleName: ${this.iconIdCache.get(bundleName)}, iconId: ${iconId}`);
    return this.iconIdCache.get(bundleName) === iconId;
  }

  /**
   * 设置负一屏是否开启
   */
  public setAppSwitch(appSwitch: boolean): void {
    this.appSwitch = appSwitch;
  }

  /**
   * 判断是否负一屏icon或者打开负一屏二级页
   */
  public static isIntelligentPageOrIcon(iconId?: string, bundleName?: string): boolean {
    return IntelligentCache.isIntelligentIconId(iconId) || (bundleName === IntelligentCache.INTELLIGENT_BUNDLE);
  }

  /**
   * 判断当前点击的负一屏ICON是否是账号头像
   */
  public static isIntelligentMyPage(iconId?: string): boolean {
    return iconId === IntelligentCache.MY_PAGE_ICON_ID;
  }

  /**
   * 判断当前点击的负一屏ICON是否是扫一扫
   */
  public static isIntelligentScanIcon(iconId?: string): boolean {
    return iconId === IntelligentCache.INTELLIGENT_HEADERAREA_SCANBUTTON_ID;
  }

  /**
   * 判断当前点击的负一屏精选服务更多
   */
  public static isIntelligentClickMoreIcon(iconId?: string): boolean {
    return iconId === IntelligentCache.INTELLIGENT_GRIDSERVICE_CLICKMORE_ID;
  }

  /**
   * 判断当前点击的负一屏ICON是否是卡片一镜到底效果
   */
  public static isIntelligentCardPage(iconId?: string): boolean {
    if (!iconId) {
      return false;
    }
    return iconId && (iconId.startsWith(IntelligentCache.STATE_MACHINE_ICON_ID) ||
      iconId === IntelligentCache.FEED_DEFAULT_ICON_ID || IntelligentCache.isIntelligentFeaturedServicesId(iconId)) ||
      iconId === IntelligentCache.MY_PAGE_ICON_ID ||
      iconId === IntelligentCache.INTELLIGENT_HEADERAREA_SCANBUTTON_ID ||
      iconId === IntelligentCache.INTELLIGENT_GRIDSERVICE_CLICKMORE_ID ||
      iconId?.startsWith(IntelligentCache.INTELLIGENT_TOOLSERVICE_PREFIX);
  }

  /**
   * 判断当前点击的ICON是否是负一屏ICON
   */
  public static isIntelligentIconId(iconId?: string): boolean {
    if (!iconId) {
      return false;
    }
    return iconId.startsWith(IntelligentCache.INTELLIGENT_PREFIX);
  }

  public static isFaIconId(iconId?: string): boolean {
    return iconId && iconId.startsWith(IntelligentCache.INTELLIGENT_FA_PREFIX);
  }

  public static isToolServiceIconId(iconId?: string): boolean {
    return iconId && iconId.startsWith(IntelligentCache.INTELLIGENT_TOOLSERVICE_PREFIX);
  }

  /**
   * 判断当前点击的ICON是否是负一屏ICON
   */
  public isCardExpandViewId(iconId?: string): boolean {
    if (!iconId) {
      return false;
    }
    return iconId.startsWith(IntelligentCache.STATE_MACHINE_CARDSTACKEXPAND_ICON_ID);
  }

  /**
   * 判断当前点击的ICON是否是负一屏精选服务ICON
   */
  public static isIntelligentFeaturedServicesId(iconId?: string): boolean {
    if (!iconId) {
      return false;
    }
    return iconId.startsWith(IntelligentCache.INTELLIGENT_FA_PREFIX) ||
    iconId.startsWith(IntelligentCache.INTELLIGENT_RECENTLY_USE_PREFIX);
  }

  /**
   * 判断iconId是否是负一屏首页存在的iconId
   */
  public isIntelligentIconInScreen(iconId: string): boolean {
    if (!iconId || !this.appSwitch) {
      return false;
    }
    return true;
  }

  /**
   * 存储ICON到缓存
   */
  public setIconCache(cacheKey: string, image: image.PixelMap): void {
    if (!image || !cacheKey) {
      log.showInfo(`setIconCache, image or cacheKey is empty, cacheKey: ${cacheKey}`);
      return;
    }
    this.deleteIconCache(cacheKey);
    this.iconCacheMap.set(cacheKey, image);
    log.showInfo(`setIconCache success:${cacheKey}`);
  }

  /**
   * 存储ICON到缓存
   */
  public setRecentlyIconCache(cacheKey: string, image: image.PixelMap): void {
    if (!image || !cacheKey) {
      log.showInfo(`setRecentlyIconCache, image or cacheKey is empty, cacheKey: ${cacheKey}`);
      return;
    }
    this.iconCacheMap.set(cacheKey, image);
    log.showInfo(`setRecentlyIconCache success:${cacheKey}`);
  }

  /**
   * 获取缓存中的图片资源
   */
  public getIconCache(cacheKey: string): image.PixelMap | undefined {
    if (!cacheKey) {
      return undefined;
    }
    return this.iconCacheMap.get(cacheKey);
  }


  /**
   * 存储iconId到缓存
   */
  public setIconIdCache(bundleName: string, cacheKey: string): void {
    if (!cacheKey || !bundleName) {
      log.showInfo(`setFaIdCache, bundleName or cacheKey is empty, cacheKey: ${cacheKey}`);
      return;
    }
    this.iconIdCache.set(bundleName, cacheKey);
    log.showInfo(`setFaIdCache success:${cacheKey}`);
  }

  /**
   * 获取iconId缓存
   */
  public getIconIdCache(bundleName: string): string | undefined {
    if (!bundleName) {
      log.showInfo(`setFaIdCache, bundleName is empty, cacheKey: ${bundleName}`);
      return undefined;
    }
    return this.iconIdCache.get(bundleName);
  }


  /**
   * 清理所有缓存
   */
  public clearAllCache(): void {
    for (let index of this.iconCacheMap.values()) {
      index?.release();
    }
    this.iconCacheMap.clear();
    this.iconIdCache.clear();
    this.iconListenerMap.clear();
    log.showInfo(`clearAllResourceCach success`);
  }

  /**
   * 清理单个ICON缓存
   */
  public deleteIconCache(cacheKey: string): void {
    this.iconCacheMap.get(cacheKey)?.release();
    this.iconCacheMap.remove(cacheKey);
    log.showInfo(`deleteIconCache success: ${cacheKey}`);
  }

  /**
   * 清理单个ICON缓存
   */
  public deleteRecentlyIconCache(cacheKey: string): void {
    this.iconCacheMap.remove(cacheKey);
    log.showInfo(`deleteRecentlyIconCache success: ${cacheKey}`);
  }

  /**
   * 使用formId，删除iconIdCache中缓存
   *
   * @param formId
   */
  public deleteIconIdCacheByFormId(formId: string): void {
    if (!formId) {
      log.showWarn('deleteIconIdCacheByFormId formId is empty');
      return;
    }
    let resultKey = '';
    let iterator: IterableIterator<[string, string]> = this.iconIdCache.entries();
    let nextResult = iterator.next();
    while (!nextResult.done) {
      const entry = nextResult.value;
      const key: string = entry[0];
      const value: string = entry[1];
      if (value === formId) {
        resultKey = key;
        break;
      }
      nextResult = iterator.next();
    }
    if (resultKey) {
      this.iconIdCache.remove(resultKey);
    }
  }

  public registerCalculateNegativeRectFun(callback: Function): void {
    this.calculateNegativeRectFun = callback;
  }

  public calculateNegativeRect(companionIconInfo: CompanionIconInfo): RectInfo | undefined {
    if (!this.calculateNegativeRectFun) {
      return undefined;
    }
    return this.calculateNegativeRectFun(companionIconInfo);
  }
}