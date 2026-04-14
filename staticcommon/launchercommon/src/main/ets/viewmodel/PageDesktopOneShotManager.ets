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
import { CheckEmptyUtils, CommonUtils, LogDomain, LogHelper, RectInfo } from '@ohos/basicutils';
import { DeviceHelper, EventConstants, GlobalContext, sEventManager } from '@ohos/frameworkwrapper';
import { ItemUtils } from '@ohos/componenthelper';
import { NumberConstants, } from '@ohos/commonconstants';
import {
  SCBSceneContainerSession,
  SCBScenePanelManager,
  SCBSceneSessionManager,
  launcherStatusUtil,
  ScenePanelState
} from '@ohos/windowscene';
import { desktopUtil } from '@ohos/componenthelper';
import {
  CardItemInfo,
  CommonConstants,
  DesktopModeManager,
  editModeManager,
  FolderManager,
  FormCenterViewManager,
  FormCommonUtil,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
  PadLaunchLayoutCacheManager,
} from '../TsIndex';
import { FormComponentModel } from '../form/model/FormComponentModel';
import { sOutSideWindowMgr, ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper';
import { dataShare, dataSharePredicates, DataShareResultSet } from '@kit.ArkData';
import taskpool from '@ohos.taskpool';
import { BusinessError } from '@ohos.base';
import { OneShotUpdateClockCardStyle } from './OneShotUpdateClockCardStyle';

const TAG = 'PageDesktopOneShotManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const CLOCK_WEATHER_PAGE: number = 0;
const CLOCK_WEATHER_CARD_NAME: string = 'ClockWeatherCard';
const CLOCK_WEATHER_BUNDLE_NAME: string = 'com.ohos.totemweather';
const CLOCK_WEATHER_HIDE_FACTOR: number = 0.005;
const CLOCK_WEATHER_DISPLAY_FACTOR: number = 1;

export class PageDesktopOneShotManager {
  private static mInstance: PageDesktopOneShotManager;
  private readonly mLauncherLayoutCacheManager: LaunchLayoutCacheManager;
  private isSatisfiedCondition: boolean = false;
  private clockWeatherLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
  private isHideClockAnimation: boolean = false;
  private isSatisfiedCardList: string[] = [];
  private clockStyle: string = '';
  private clockCardIdList: string[] = [];
  private mFormScale: ScaleOptions = {
    x: NumberConstants.CONSTANT_NUMBER_ONE,
    y: NumberConstants.CONSTANT_NUMBER_ONE
  }
  private isBaseDeskTopPage: boolean = false;
  private outStatus: boolean = false;
  private isRetryUpdateCardStyle: boolean = false;

  /**
   * 再次更新卡片样式
   */
  public retryUpdateCardStyle(): void {
    if (!this.isRetryUpdateCardStyle) {
      return;
    }
    log.showInfo(`notify update card style after layout init finished`);
    this.clockCardIdList = this.getAllClockWeatherCard();
    if (this.clockCardIdList.length !== 0) {
      this.updateCardStyle();
      this.isRetryUpdateCardStyle = false;
    }
  }

  /**
   * 设置isBaseDeskTopPage
   */
  public setIsBaseDeskPage(): void {
    this.isBaseDeskTopPage = this.isBaseDeskPage();
    log.showInfo(`setIsBaseDeskPage PowerStatusMonitor isBaseDeskTopPage:${this.isBaseDeskTopPage}`);
  }

  /**
   * 获取isBaseDeskTopPage
   *
   * @returns
   */
  public getIsBaseDeskPage(): boolean {
    return this.isBaseDeskTopPage;
  }

  static getInstance(): PageDesktopOneShotManager {
    if (!PageDesktopOneShotManager.mInstance) {
      PageDesktopOneShotManager.mInstance = new PageDesktopOneShotManager();
    }
    return PageDesktopOneShotManager.mInstance;
  }

  private constructor() {
    this.mLauncherLayoutCacheManager = DeviceHelper.isPad() ? PadLaunchLayoutCacheManager.getInstance() :
    LaunchLayoutCacheManager.getInstance();
    this.getSatisfiedCardList().then(() => {
      this.isSatisfiedOneShotAnimation();
    });
    this.listenStartClockAnimation();
    this.listenScreenLockBeginSleep();
  }
  //是否处于多任务状态
  public isRecentState(): boolean {
    let scenePanelState: ScenePanelState = AppStorage.get<ScenePanelState>('scenePanelState') as ScenePanelState;
    return scenePanelState === ScenePanelState.RECENT;
  }

  public getTopActiveFloatContainer(): SCBSceneContainerSession | null {
    let list = SCBScenePanelManager.getInstance().getFloatingSessionList().getActiveSessionList();
    if (CommonUtils.isInvalid(list) || list.length === 0) {
      return null;
    }
    for (let i = list.length - 1; i >= 0; i--) {
      if (list[i].haveActiveSession()) {
        return list[i];
      }
    }
    return null;
  }

  //是否要走动效,桌面和一镜到底共有判断部分：true为要走动效
  public needAnimate(): boolean {
    let pageIndex: number = desktopUtil.getPageIndexValue();
    let formStackOpen: boolean = AppStorage.get<boolean>('formStackEditShow') as boolean;
    let scenePanelState: number = AppStorage.get<number>('scenePanelState') as number;
    let showGlobalSearch: boolean = sOutSideWindowMgr.isShowGlobalSearch();
    let showNagativeScreen: boolean = ViewManagerPolicy.isViewShowing(ViewType.NEGATIVE_SCREEN);
    let activeSessionListIsEmpty: boolean = SCBSceneSessionManager.getInstance().checkActiveSessionListIsEmpty();
    let floatContainer = this.getTopActiveFloatContainer();
    // 锁屏状态下窗口会将scenePanelState置为0,如果当前为应用页面，会将应用id写入集合，解锁时取出id并将集合清空，同时需要判断全搜和负一屏
    let isOnHome: boolean = scenePanelState === 0 && activeSessionListIsEmpty &&
      !showGlobalSearch && !showNagativeScreen;
    const isFolderOpen: boolean = FolderManager.getInstance().isFolderOpen();
    if (isFolderOpen || editModeManager.isInEditMode() ||
    FormCenterViewManager.getInstance().isFormCenterViewShowing() ||
      formStackOpen || this.isRecentState() || !isOnHome || !CheckEmptyUtils.isEmpty(floatContainer)) {
      if (pageIndex === 0) {
        log.showInfo(`current page pageIndex:${pageIndex},activeSessionListIsEmpty:${activeSessionListIsEmpty},
      showGlobalSearch:${showGlobalSearch},showNagativeScreen:${showNagativeScreen},scenePanelState:${scenePanelState},
      and floatContainer:${floatContainer}`);
      }
      return false;
    }
    return true;
  }

  //判断是否是桌面状态，而不是二级页面场景 做不做动效；true为是桌面状态 要做动效
  public isBaseDeskPage(): boolean {
    let onDeskTop: boolean = AppStorage.get<boolean>('onDeskTop') as boolean;
    if (!this.needAnimate() || !onDeskTop) {
      return false;
    }
    return true;
  }

  /**
   * 查询首页是否满足一镜到底
   *
   * @returns 是否满足一镜到底
   */

  isSatisfiedOneShotAnimation(): boolean {
    let pageIndex: number = desktopUtil.getPageIndexValue();
    let isInEmergencyOrThermalSafeMode: boolean = DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode();
    // 如果当前页不在首页或处于打开应用状态以及全搜和负一屏状态时则返回false
    let needAnimate: boolean = this.needAnimate();
    if (pageIndex !== 0 || isInEmergencyOrThermalSafeMode || !needAnimate) {
      return this.satisfiedCondition(false,
        `pageIndex:${pageIndex}, SafeMode:${isInEmergencyOrThermalSafeMode}, needAnimate:${needAnimate}`);
    }
    if (CheckEmptyUtils.isEmptyArr(this.isSatisfiedCardList)) {
      return this.satisfiedCondition(false, 'Satisfied Card List is empty');
    }
    let gridLayoutItemInfo: GridLayoutItemInfo[] = this.mLauncherLayoutCacheManager
      .selectGridLayoutItemsByPage(CLOCK_WEATHER_PAGE);
    if (CheckEmptyUtils.isEmptyArr(gridLayoutItemInfo)) {
      return this.satisfiedCondition(false, 'GridLayout is empty');
    }
    let cardNames: string[] = [];
    gridLayoutItemInfo = gridLayoutItemInfo.filter((item: GridLayoutItemInfo) => {
      if (item.bundleName === CLOCK_WEATHER_BUNDLE_NAME && !CheckEmptyUtils.checkStrIsEmpty(item.cardId)) {
        if (item.cardName === CLOCK_WEATHER_CARD_NAME) {
          // 通过卡片名称与应用包名可以确定为天气时钟卡片
          return true;
        }
        cardNames.push(item.cardName ?? '');
      }
      return false;
    });
    if (CheckEmptyUtils.isEmptyArr(gridLayoutItemInfo)) {
      return this.satisfiedCondition(false, `card is empty ${JSON.stringify(cardNames)}`);
    }
    gridLayoutItemInfo.sort((itemA: GridLayoutItemInfo, itemB: GridLayoutItemInfo) => {
      return this.compareGridLayoutItemByLocation(itemA, itemB);
    });
    // 通过卡片名称与应用包名可以确定为天气时钟卡片
    for (let i = 0; i < gridLayoutItemInfo.length; i++) {
      let item: GridLayoutItemInfo = gridLayoutItemInfo[i];
      // 鉴别天气卡片是否为目标卡片，即排除双城天气以及与系统时区不一致的卡片
      let index = this.isSatisfiedCardList.findIndex(satisfiedCard => {
        return satisfiedCard === String(item.cardId);
      });
      if (index !== -1) {
        this.clockWeatherLayout = item;
        return this.satisfiedCondition(true,
          `row:${this.clockWeatherLayout.row}, column:${this.clockWeatherLayout.column}`);
      }
    }
    return this.satisfiedCondition(false, 'end');
  }

  private satisfiedCondition(isSatisfiedCondition: boolean, reason: string): boolean {
    this.isSatisfiedCondition = isSatisfiedCondition;
    let str: string = `isSatisfiedOneShotAnimation return ${isSatisfiedCondition} for ${reason}`;
    if (isSatisfiedCondition) {
      log.showInfo(str);
    } else {
      log.showWarn(str);
    }
    return this.isSatisfiedCondition;
  }

  /**
   * 获取首页时钟卡片位置
   *
   * @returns 返回首页第一张天气时钟卡片的位置信息
   */
  getClockPosition(): RectInfo {
    if (!this.isSatisfiedCondition) {
      log.showDebug(`not satisfied oneShot animation`);
      return new RectInfo();
    }
    if (CheckEmptyUtils.isEmpty(this.clockWeatherLayout)) {
      log.showWarn('getClockPosition error, clockWeatherLayout is empty');
      return new RectInfo();
    }
    let cardItem = new CardItemInfo();
    cardItem.bundleName = this.clockWeatherLayout.bundleName;
    cardItem.cardId = this.clockWeatherLayout.cardId ?? '';
    let formItemId: string = FormCommonUtil.getFormComponentId(cardItem);
    let formItemRectInfo: RectInfo = ItemUtils.getRectById(formItemId);
    return formItemRectInfo;
  }

  /**
   * 通知卡片隐藏天气时钟卡片
   */
  notifiyFormHideCard(): void {
    if (this.isHideClockAnimation && this.isSatisfiedCondition) {
      log.showInfo(`start to hide card, the cardid is ${this.clockWeatherLayout.cardId}`);
      FormComponentModel.getInstance().setFormOpacity(this.clockWeatherLayout, CLOCK_WEATHER_HIDE_FACTOR);
    } else {
      log.showWarn(`not satisfied oneShot animation,failed to hide card`);
    }
  }

  /**
   * 监听卡片恢复事件，桌面通知卡片展示天气时钟卡片
   */
  private listenStartClockAnimation(): void {
    sEventManager.subscribe(EventConstants.DESKTOP_CLOCK_ANIMATION_START, () => {
      this.isHideClockAnimation = false;
      log.showInfo(`start showForm clockAnimation, the cardid is ${this.clockWeatherLayout.cardId}`);
      FormComponentModel.getInstance().setFormOpacity(this.clockWeatherLayout, CLOCK_WEATHER_DISPLAY_FACTOR);
    });
  }

 /**
  * 为锁屏提供通知更新天气时钟卡片样式的入口
  *
  * @param styleParam 要更新的卡片样式
  */
  public notifyUpdateCardStyle(styleParam: string): void {
    let currentOutStatus: boolean = launcherStatusUtil.getShowOutLauncherStatus();
    log.showInfo(`notifyUpdateCardStyle update style is ${styleParam} and current stype is ${this.clockStyle},outStatus:${this.outStatus},currentOutStatus:${currentOutStatus}`);
    if (!CheckEmptyUtils.isEmpty(styleParam) && this.clockStyle === styleParam && this.outStatus === currentOutStatus) {
      log.showInfo(`notifyUpdateCardStyle update stype equals current style and do not need update clockStyle`);
      return;
    }
    let cardIdList: string[] = this.getAllClockWeatherCard();
    //保存该参数用于回调
    this.clockStyle = styleParam;
    OneShotUpdateClockCardStyle.getInstance().setClockStyle(styleParam);
    this.clockCardIdList = cardIdList;
    if (this.clockCardIdList.length !== 0) {
      this.updateCardStyle();
    } else {
      this.isRetryUpdateCardStyle = true;
    }
  }

  /**
   * 桌面通知更新天气时钟卡片样式
   */
  private updateCardStyle(): void {
    this.clockCardIdList.forEach((cardId) => {
      let wantParams: Record<string, Object> = {
        'ONE_MIRROR_CHANGE': 'true',
        'STYLE_PARAMETERS': this.clockStyle
      };
      log.showInfo(`start update Clock Animation, the cardid is ${cardId}`);
      FormCommonUtil.requestFormWithParams(cardId, wantParams);
    });
  }



  /**
   * 监听息屏操作，将耗时查询放置该回调中
   */
  private listenScreenLockBeginSleep(): void {
    sEventManager.subscribe(EventConstants.SCREEN_LOCK_BEGIN_SLEEP, async () => {
      await this.getSatisfiedCardList();
    });
  }

  /**
   * 查询所有桌面天气时钟卡片
   *
   * @returns 返回天气时钟卡片ID集合
   */
  private getAllClockWeatherCard(): string[] {
    let cardId: string[] = [];
    let clockWeatherCard: GridLayoutItemInfo[] = this.mLauncherLayoutCacheManager
      .selectGridLayoutItemsByType(CommonConstants.TYPE_CARD);
    // 只获取天气时钟卡片
    clockWeatherCard.forEach(item => {
      if (item.bundleName === CLOCK_WEATHER_BUNDLE_NAME &&
        !CheckEmptyUtils.isEmpty(item.cardId)) {
        cardId.push(item.cardId as string);
      }
    });
    return cardId;
  }

  /**
   * 比较应用信息的位置，用于排序
   *
   * @returns 比较值大小
   */
  private compareGridLayoutItemByLocation(itemA: GridLayoutItemInfo, itemB: GridLayoutItemInfo): number {
    if (itemA.row === undefined || itemA.column === undefined || itemB.row === undefined ||
      itemB.column === undefined) {
      log.showWarn('compareGridLayout failure as item is null');
      return 0;
    }
    return itemA.row !== itemB.row ? (itemA.row - itemB.row) : (itemA.column - itemB.column);
  }

  /**
   * 判断是否为需要隐藏的天气时钟卡片
   *
   * @returns 判断结果
   */
  isClockWeatherCard(item: GridLayoutItemInfo): boolean {
    if (this.isHideClockAnimation && this.isSatisfiedCondition && this.isEquals(item)) {
      log.showInfo(`the card is clockweathercard,cardid is ${item.cardId}`);
      this.isHideClockAnimation = false;
      return true;
    }
    return false;
  }

  /**
   * 判断卡片是否与首页天气时钟卡片相等
   *
   * @param item 需要判断的卡片信息
   * @returns true:相等 false:不相等
   */
  public isEquals(item: GridLayoutItemInfo | CardItemInfo): boolean {
    if (CheckEmptyUtils.isEmpty(item)) {
      return false;
    }
    if (item.bundleName === CLOCK_WEATHER_BUNDLE_NAME && !CheckEmptyUtils.isEmpty(item.cardId) &&
      item.cardId === this.clockWeatherLayout.cardId) {
      log.showInfo(`the card is clockweathercard,cardid is ${item.cardId}`);
      return true;
    }
    return false;
  }

  /**
   * 仅供锁屏一镜到底场景设置隐藏标识，其他场景请勿调用
   */
  setIsHideClockAnimation(isHideClockAnimation: boolean): void {
    this.isHideClockAnimation = isHideClockAnimation;
  }

  /**
   * 设置屏幕旋转时的缩放比例及缩放中心
   *
   * @param scaleX 缩放比例x
   * @param scaleY 缩放比例y
   * @param centerX 缩放中心x
   * @param centerY 缩放中心y
   */
  setFormScale(scaleX: number, scaleY: number, centerX: string, centerY: string): void {
    this.mFormScale.x = scaleX;
    this.mFormScale.y = scaleY;
    this.mFormScale.centerX = centerX;
    this.mFormScale.centerY = centerY;
    log.showInfo(`set scaleX :${this.mFormScale.x},scaleY :${this.mFormScale.y}`);
  }

  /**
   * 获取卡片的屏幕旋转时的比例及缩放中心
   *
   * @returns 缩放比例及缩放中心
   */
  getItemScale(): ScaleOptions {
    return this.mFormScale
  }

  /**
   * 获取时钟卡片的维度
   *
   * @returns 卡片维度
   */
  getCardDimension(): number {
    if (this.clockWeatherLayout.area) {
      let cardDimension: number = CardItemInfo.getCardDimension(this.clockWeatherLayout.area);
      log.showInfo(`getCardDimension :${cardDimension}`);
      return cardDimension;
    }
    return CommonConstants.INVALID_VALUE;
  }

  public async getSatisfiedCardList(): Promise<void> {
    let result: string[] = await taskpool.execute(dataShareQuery, GlobalContext.getContext()) as string[];
    this.isSatisfiedCardList = result;
    log.showDebug(`getSatisfiedCardList isSatisfiedCardList:${this.isSatisfiedCardList}`);
  }
}

/**
 * 访问日历数据库,查询当前卡片是那种类型
 *
 * @returns 返回所有卡片名称为'ClockWeatherCard',且不为双城卡片以及时区与系统时区一致的卡片
 */
async function dataShareQuery(context: Context): Promise<Array<string>> {
  'use concurrent';
  const TAG = 'PageDesktopOneShotManager';
  const CLOCK_WEATHER_CARD_NAME: string = 'ClockWeatherCard';
  const URI_SHARE = 'datashareproxy://com.ohos.totemweather/card';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  let isSatisfiedCardList: string[] = [];
  let result: DataShareResultSet | undefined = undefined;
  let helper: dataShare.DataShareHelper | undefined = undefined;
  try {
    helper = await dataShare.createDataShareHelper(context, URI_SHARE, { isProxy: true });
    if (!helper) {
      log.showError('helper is null or undefined');
      return isSatisfiedCardList;
    }
    const predicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo('form_name', CLOCK_WEATHER_CARD_NAME);
    result = await helper.query(URI_SHARE, predicates, ['*']);
    result.goToFirstRow();
    let cardSize: number = result.rowCount;
    if (cardSize === 0) {
      log.showInfo('Query no results!');
      result?.close();
      helper?.close();
      return isSatisfiedCardList;
    }
    for (let i = 0; i < cardSize; i++) {
      let formId: string = result.getString(result.getColumnIndex('form_id'));
      let isDouble: number = result.getLong(result.getColumnIndex('isDouble'));
      let isSystemTimezone: number = result.getLong(result.getColumnIndex('isSystemTimezone'));
      let cityId: number = result.getLong(result.getColumnIndex('city_id'));
      log.showInfo(`formId:${formId},isDouble:${isDouble},isSystemTimezone:${isSystemTimezone},cityId:${cityId}`);
      // 不为双城卡片且与系统应用的时区相同
      if (isDouble === 1 || (cityId > 0 && isSystemTimezone === 0)) {
        result.goToNextRow();
        continue;
      }
      isSatisfiedCardList.push(formId);
      result.goToNextRow();
    }
  } catch (e) {
    let error = e as BusinessError;
    log.showError(`query weather db error code:${error.code},message :${error.message}`);
  }
  result?.close();
  helper?.close();
  return isSatisfiedCardList;
}