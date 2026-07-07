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

import Want from '@ohos.app.ability.Want';
import {
  CardItemInfo,
  CommonConstants,
  DockItemInfo,
  FolderAppItemInfo,
  FolderItemInfo,
  FormCommonUtil,
  FormLocation,
  GridLayoutItemInfo,
  ResidentLayoutCacheMgr,
} from '@ohos/launchercommon';
import { CheckEmptyUtils, CommonUtils, JsonUtils, LogDomain, LogHelper, StartType } from '@ohos/basicutils';
import { SCBTransitionController, SCBTransitionManager } from '@ohos/windowscene';
import ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
import { AiSuggestionConstants } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';
import { JsonHelper } from '../utils/JsonHelper';
import { PortfolioInfoDisplayMode } from '../constants/PortfolioInfoDisplayMode';
import { AiSuggestionResourceManager } from '../manager/AiSuggestionResourceManager';
import { NeedDelayShow } from '../constants/NeedDelayShow';
import { AbilityFormUtil } from '../utils/AbilityFormUtil';
import { LauncherScreenFaItem } from '../bean/LauncherScreenFaItem';
import { LauncherScreenItem } from '../bean/LauncherScreenItem';
import { LauncherCardInfo } from '../bean/LauncherCardInfo';
import { LauncherFolderInfo } from '../bean/LauncherFolderInfo';
import { LauncherStackInfo } from '../bean/LauncherStackInfo';
import { FormStackItemInfo } from '@ohos/formstack/src/main/ets/common/FormStackItemInfo';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';
import { LauncherDisplayCardInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherDisplayCardInfo';
import { PortfolioInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/PortfolioInfo';
import { CardResourceInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/CardResourceInfo';
import { ExtraData } from '@ohos/launchercommon/src/main/ets/aisuggestion/ExtraData';

const TAG = 'AiSuggestionDataHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * AiSuggestionDataHelper
 *
 * @since 2025-06-11
 */
export class AiSuggestionDataHelper {
  /**
   * 点击应用时，获取点击的应用的数据
   *
   * @param recItem 点击的应用
   * @param recItems 应用列表
   * @returns 被点击应用的数据
   */
  public static getRealRecItem(recItem: LauncherRecItem, recItems: LauncherRecItem[]): LauncherRecItem | undefined {
    if (!recItem || !recItems) {
      log.showWarn('getRealRecItem params invalid');
      return undefined;
    }
    for (let item of recItems) {
      if (recItem.itemType === AiSuggestionConstants.TYPE_APP &&
        item.itemType === AiSuggestionConstants.TYPE_APP_GROUP) {
        const findRecItem = item.subLauncherRecItems.find(subItem => subItem.serviceId === recItem.serviceId);

        // 应用组有可能多个找不到继续遍历
        if (!findRecItem) {
          continue;
        }
        return findRecItem;
      }
      if (item.serviceId === recItem.serviceId) {
        return item;
      }
    }
    return recItem;
  }

  /**
   * 打印日志
   *
   * @param formItem 母卡
   * @param displayCardInfo 当前显示的内容
   * @param portfolioInfo 卡片的场景信息
   */
  public static logDisplayCardInfo(formItem: GridLayoutItemInfo, displayCardInfo: LauncherDisplayCardInfo | undefined,
    portfolioInfo: PortfolioInfo | undefined): void {
    log.showError('onUpdate cardId:%{public}s, displayInfo:%{public}s',
      formItem?.cardId, JSON.stringify(displayCardInfo, JsonHelper.logReplacer));
    if (portfolioInfo?.portfolioId) {
      log.showError('onUpdate portfolioInfo:%{public}s', JSON.stringify(portfolioInfo, JsonHelper.logReplacer));
    }
  }

  /**
   * 判断是否需要显示场景信息
   *
   * @param portfolioInfo 场景信息
   * @param isArrivedTime 计时器是否到期
   * @returns true 表示需要显示
   */
  public static isNeedShowPortfolioInfo(portfolioInfo: PortfolioInfo | undefined, isArrivedTime: boolean): boolean {
    return portfolioInfo?.displayMode === PortfolioInfoDisplayMode.DISPLAY_MODE_EXIST ||
      (portfolioInfo?.displayMode === PortfolioInfoDisplayMode.DISPLAY_MODE_DISAPPEAR &&
        !isArrivedTime);
  }

  /**
   * 获取创建卡片时需要传给卡片框架的参数
   *
   * @param recItem 卡片信息
   * @param formItem 母卡信息
   * @param disableGesture 是否禁止手势
   * @returns 返回传给卡片框架的参数
   */
  public static getWant(recItem: LauncherRecItem, formItem: GridLayoutItemInfo, disableGesture?: boolean): Want {
    if (!recItem || !formItem) {
      log.showWarn('getWant params invalid');
      return {};
    }
    let want: Want = FormCommonUtil.getCommonWant({
      isTransparent: recItem.isTransparent,
      formLocation: FormLocation.AI_SUGGESTION,
      disableGesture: disableGesture,
    });

    if (!want.parameters) {
      want.parameters = {};
    }

    if (!CommonUtils.isEmpty(recItem.formWantInfo)) {
      want.parameters[AiSuggestionConstants.FORM_WANT_INFO] = recItem.formWantInfo;
      AbilityFormUtil.appendParams(recItem.formWantInfo, want.parameters);
      log.showInfo(`addExtraWantParam voice: ${formItem.cardId} cardId: ${recItem.cardId} add formWantInfo`);
    }
    if (recItem.recInfo) {
      recItem.recInfo.parentFormId = formItem.cardId ?? '';
      want.parameters[AiSuggestionConstants.REC_INFO] = JsonUtils.toJson(recItem.recInfo);
      log.showInfo(`addExtraWantParam voice: ${formItem.cardId} cardId: ${recItem.cardId} add recInfo`);
    }
    return want;
  }

  /**
   * 加载场景卡图片
   *
   * @param picResId 资源id
   */
  public static async getPortfolioPic(picResId: string): Promise<string> {
    let portfolioPicUrl: string | undefined = '';
    if (!picResId) {
      log.showDebug('getPortfolioPic picResId invalid');
      return portfolioPicUrl;
    }
    await AiSuggestionResourceManager.getInstance().getResource(picResId)?.then((url) => {
      portfolioPicUrl = url;
    }).catch((error: Error) => {
      log.showError('getPortfolioPic resource failed:%{public}s', error.message);
    });
    return portfolioPicUrl;
  }

  /**
   * 卡片名称显示是否需要动效
   *
   * @param createFormId 卡片中心返回的卡片id
   * @param cardId 当前的卡片id
   * @returns 是否需要执行动效
   */
  public static isPlayCreateAnimation(createFormId: string, cardId: string | undefined): boolean {
    let isCreateFormAnimation: boolean = false;
    if (!AbilityFormUtil.isCardIdInvalid(createFormId) && createFormId === cardId) {
      log.showInfo('add form %{public}s', createFormId);
      isCreateFormAnimation = true;
    }
    return isCreateFormAnimation;
  }

  /**
   * 获取场景卡深浅色配置信息
   *
   * @param curColorMode 当前模式（深浅色）
   * @param portfolioInfo 场景信息
   * @returns 深浅色的配置信息
   */
  public static getPortfolioRes(curColorMode: ConfigurationConstant.ColorMode,
    portfolioInfo: PortfolioInfo | undefined): CardResourceInfo | undefined {
    let portfolioRes: CardResourceInfo | undefined = portfolioInfo?.light;
    if (curColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      portfolioRes = portfolioInfo?.dark ?? portfolioInfo?.light;
    }
    return portfolioRes;
  }

  /**
   * 根据卡片信息获取卡片ID
   *
   * @param item 卡片信息
   * @returns 卡片ID
   */
  public static getFormId(item: LauncherRecItem): string {
    if (!item) {
      log.showInfo('getFormId param invalid');
      return '';
    }
    let info: CardItemInfo = new CardItemInfo();
    info.cardId = item.cardId;
    info.bundleName = item.bundleName;
    return FormCommonUtil.getFormComponentId(info);
  }

  /**
   * 判断场景信息是否需要显示
   *
   * @param recItem 推荐的卡片信息
   * @param portfolioInfo 场景信息
   * @param isArrivedTime 计时器是否已经到期
   * @param sceneSpan 间距
   * @returns true 场景信息需要显示
   */
  public static checkDisplay(recItem: LauncherRecItem, portfolioInfo: PortfolioInfo | undefined, isArrivedTime: boolean,
    sceneSpan: number[]): boolean {
    if (!recItem) {
      log.showWarn('checkDisplay recItem invalid');
      return false;
    }
    if (!portfolioInfo?.portfolioId) {
      return true;
    }
    if ((portfolioInfo?.displayMode === PortfolioInfoDisplayMode.DISPLAY_MODE_DISAPPEAR &&
      !isArrivedTime && recItem.needDelayShow === NeedDelayShow.NEED_DELAY_SHOW) ||
      (portfolioInfo?.displayMode === PortfolioInfoDisplayMode.DISPLAY_MODE_EXIST &&
      AiSuggestionDataHelper.checkShowAlwaysExist(recItem, sceneSpan))) {
      // 不显示
      return false;
    }
    // 显示
    return true;
  }

  private static checkShowAlwaysExist(recItem: LauncherRecItem, sceneSpan: number[]): boolean {
    if (sceneSpan[0] >= recItem.rowStart + recItem.rowSpan &&
      sceneSpan[1] >= recItem.columnStart + recItem.columnSpan) {
      log.showInfo('checkShowAlwaysExist true.');
      return true;
    }
    log.showInfo('checkShowAlwaysExist false.');
    return false;
  }

  public static getAppGroupBgColor(curColorMode: ConfigurationConstant.ColorMode,
    portfolioInfo: PortfolioInfo | undefined): ResourceColor {
    if (curColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      return $r('app.color.app_group_dark_bg_color');
    }

    if (!portfolioInfo || CheckEmptyUtils.isEmpty(portfolioInfo.backBoardStyle)) {
      return $r('app.color.app_group_light_bg_color');
    }
    return portfolioInfo.backBoardStyle === 0 ?
    $r('app.color.app_group_light_bg_color') : $r('app.color.app_group_dark_bg_color');
  }

  /**
   * 注册转场动效控制器
   *
   * @param formItem 母卡片
   * @param iconRadius 圆角
   * @param onActive 可见回调
   * @param onInactive 不可见回调
   * @param item 子服务
   * @returns 转场动效控制器
   */
  public static regTransController(formItem: GridLayoutItemInfo, iconRadius: number, onActive: Function,
    onInactive: Function, item?: LauncherRecItem): SCBTransitionController | undefined {
    if (!formItem || !onActive || !onInactive) {
      log.showError('regTransController formItem params undefined');
      return undefined;
    }
    const transitionController: SCBTransitionController = {
      appData: {
        bundleName: item ? item.bundleName : formItem.bundleName,
        abilityName: item ? item.abilityName : formItem.abilityName,
        appIconId: item ? AiSuggestionDataHelper.getFormId(item) :
        FormCommonUtil.getFormComponentId(formItem),
        iconRadius: iconRadius,
        appIconNumber: item ? Number(item.cardId) : Number(formItem.cardId),
        cardId: item ? item.cardId : formItem.cardId,
        startAppType: StartType.CARD,
        extraId: formItem.cardId,
      },
      cardDimension: item ? item.dimension : formItem.cardDimension,
      onActive: onActive,
      onInactive: onInactive,
    };
    SCBTransitionManager.getInstance().registerTransitionController(transitionController);
    return transitionController;
  }

  /**
   * 获取默认卡
   *
   * @param formItem 母卡信息
   * @returns 默认卡
   */
  public static getDefaultLaunchCardInfo(formItem: GridLayoutItemInfo, createFormId?: string): LauncherCardInfo {
    let cardInfo: LauncherCardInfo = new LauncherCardInfo();
    let disPlayCardInfo = new LauncherDisplayCardInfo();
    let portfolioInfo = new PortfolioInfo();
    portfolioInfo.portfolioId = ExtraData.getPortfolioId(formItem);
    cardInfo.cardUniqueTag = ExtraData.getCardUniqueTag(formItem) ?? '';
    cardInfo.portfolioInfo = portfolioInfo;
    disPlayCardInfo.recItems = [AiSuggestionDataHelper.getDefaultCard(formItem, createFormId)];
    disPlayCardInfo.rowsTemplate = Array(formItem.cardDimension).fill('1fr').join(' ');
    disPlayCardInfo.columnsTemplate = Array(formItem.cardDimension).fill('1fr').join(' ');
    cardInfo.portrait = disPlayCardInfo;
    return cardInfo;
  }

  /**
   * 获取默认卡
   *
   * @param formItem 母卡信息
   * @returns 默认卡
   */
  public static getDefaultCard(formItem: GridLayoutItemInfo, createFormId?: string): LauncherRecItem {
    let cardDimension = formItem.cardDimension;
    log.showInfo(`getDefaultCard cardDimension = ${cardDimension}, ${formItem.cardId}`);
    if (cardDimension === undefined) {
      cardDimension = CardItemInfo.getCardDimension(formItem.area);
      log.showWarn(`formItem.cardDimension = ${cardDimension} area = ${formItem.area}`);
    }
    const launcherRecItem = new LauncherRecItem();
    launcherRecItem.bundleName = formItem.bundleName;
    launcherRecItem.moduleName = formItem.moduleName ?? '';
    launcherRecItem.abilityName = formItem.abilityName;
    launcherRecItem.extend1 = formItem.extend1;
    launcherRecItem.dimension = formItem.cardDimension ?? 0;
    launcherRecItem.formName = formItem.cardName ?? '';
    launcherRecItem.rowStart = 0;
    launcherRecItem.columnStart = 0;
    if (createFormId) {
      launcherRecItem.cardId = createFormId;
      launcherRecItem.isCreating = true;
    }
    launcherRecItem.itemType = CommonConstants.TYPE_CARD;
    launcherRecItem.rowSpan = formItem.cardDimension ?? 0;
    launcherRecItem.columnSpan = formItem.cardDimension ?? 0;
    launcherRecItem.formWantInfo = JSON.stringify({
      host: CommonConstants.LAUNCHER_BUNDLE
    });
    return launcherRecItem;
  }

  /**
   * 获取桌面上某一屏的应用列表
   *
   * @param layoutInfo 桌面的布局信息
   * @param screenIndex 桌面索引
   * @returns 应用列表
   */
  public static getApps(layoutInfo: Array<GridLayoutItemInfo>, screenIndex: number): Array<LauncherScreenItem> {
    return layoutInfo.filter(gridLayoutItemInfo => gridLayoutItemInfo.typeId === CommonConstants.TYPE_APP &&
      screenIndex === gridLayoutItemInfo.page).map(gridLayoutItemInfo => {
      let screenItem = new LauncherScreenItem();
      screenItem.page = gridLayoutItemInfo.page ?? -1;
      screenItem.bundleName = gridLayoutItemInfo.bundleName;
      screenItem.moduleName = gridLayoutItemInfo.moduleName ?? '';
      screenItem.abilityName = gridLayoutItemInfo.abilityName;
      screenItem.typeId = gridLayoutItemInfo.typeId ?? 0;
      screenItem.appIndex = gridLayoutItemInfo.appIndex ?? 0;
      return screenItem;
    });
  }

  /**
   * 获取桌面上某一屏的卡片列表
   *
   * @param layoutInfo 桌面的布局信息
   * @param screenIndex 桌面索引
   * @returns 卡片列表
   */
  public static getForms(layoutInfo: Array<GridLayoutItemInfo>, screenIndex: number): Array<LauncherScreenFaItem> {
    return layoutInfo.filter(gridLayoutItemInfo => gridLayoutItemInfo.typeId === CommonConstants.TYPE_CARD &&
      screenIndex === gridLayoutItemInfo.page).map(gridLayoutItemInfo => {
      return AiSuggestionDataHelper.getScreenFaItem(gridLayoutItemInfo);
    });
  }

  /**
   * 获取dock栏的应用列表
   *
   * @param isOuter 内屏还是外屏
   * @returns 应用列表
   */
  public static getDocker(isOuter?: boolean): LauncherScreenItem[] {
    const residentList: DockItemInfo[] | undefined = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    if (!residentList || isOuter) {
      log.showWarn(`dockers is empty`);
      return [];
    }
    return residentList.map((dockItemInfo) => {
      let screenItem = new LauncherScreenItem();
      screenItem.bundleName = dockItemInfo.bundleName;
      screenItem.moduleName = dockItemInfo.moduleName ?? '';
      screenItem.abilityName = dockItemInfo.abilityName;
      screenItem.typeId = dockItemInfo.itemType ?? 0;
      screenItem.appIndex = dockItemInfo.appIndex ?? 0;
      return screenItem;
    });
  }

  /**
   * 获取某一屏的文件夹列表
   *
   * @param layoutInfo 桌面的布局信息
   * @param screenIndex 屏幕索引
   * @returns 文件夹列表
   */
  public static getFolders(layoutInfo: GridLayoutItemInfo[], screenIndex: number): LauncherFolderInfo[] {
    let launcherFolderInfoList: LauncherFolderInfo[] = [];
    if (!layoutInfo) {
      log.showWarn('getFolders invalid layoutInfo');
      return launcherFolderInfoList;
    }
    layoutInfo.filter(gridLayoutItemInfo => gridLayoutItemInfo.typeId === CommonConstants.TYPE_FOLDER &&
      screenIndex === gridLayoutItemInfo.page).forEach(gridlayoutItemInfo => {
      let folderItemInfo = gridlayoutItemInfo as Object as FolderItemInfo;
      let launcherFolderInfo = new LauncherFolderInfo();
      if (folderItemInfo.area?.length >= 2) {
        launcherFolderInfo.width = folderItemInfo.area[0];
        launcherFolderInfo.height = folderItemInfo.area[1];
      }
      launcherFolderInfo.itemList = [];
      launcherFolderInfoList.push(launcherFolderInfo);
      for (let i = 0; i < folderItemInfo.layoutInfo.length; i++) {
        let appInfoList = folderItemInfo.layoutInfo[i];
        appInfoList.slice(0, 9).forEach(item => {
          launcherFolderInfo.itemList.push(AiSuggestionDataHelper.getScreenItem(item));
        });
      }
    });
    return launcherFolderInfoList;
  }

  /**
   * 获取某一屏的堆叠列表
   *
   * @param layoutInfo 桌面的布局信息
   * @param screenIndex 屏幕索引
   * @returns 堆叠列表
   */
  public static getStacks(layoutInfo: GridLayoutItemInfo[], screenIndex: number): LauncherStackInfo[] {
    let launcherStackInfoList: LauncherStackInfo[] = [];
    if (!layoutInfo) {
      log.showWarn('getStacks invalid layoutInfo');
      return launcherStackInfoList;
    }
    layoutInfo.filter(gridLayoutItemInfo => gridLayoutItemInfo.typeId === CommonConstants.TYPE_FORM_STACK &&
      screenIndex === gridLayoutItemInfo.page).forEach(gridLayoutItemInfo => {
      let formStackItemInfo = gridLayoutItemInfo as Object as FormStackItemInfo;
      let launcherStackInfo = new LauncherStackInfo();
      launcherStackInfo.stackId = formStackItemInfo.formStackId ?? '';
      launcherStackInfo.faItems = [];
      launcherStackInfoList.push(launcherStackInfo);
      for (let i = 0; i < formStackItemInfo.layoutInfo.length; i++) {
        let carItemInfoList = formStackItemInfo.layoutInfo[i];
        carItemInfoList.forEach((item: CardItemInfo, index: number) => {
          launcherStackInfo.faItems.push(AiSuggestionDataHelper.getScreenFaItemByCardItemInfo(item, index));
        });
      }
    });
    return launcherStackInfoList;
  }

  private static getScreenFaItem(gridLayoutItemInfo: GridLayoutItemInfo): LauncherScreenFaItem {
    let screenFaItem = new LauncherScreenFaItem();
    screenFaItem.cardName = gridLayoutItemInfo.cardName ?? '';
    screenFaItem.dimension = CardItemInfo.getCardDimension(gridLayoutItemInfo.area);
    screenFaItem.bundleName = gridLayoutItemInfo.bundleName;
    screenFaItem.moduleName = gridLayoutItemInfo.moduleName ?? '';
    screenFaItem.abilityName = gridLayoutItemInfo.abilityName;
    screenFaItem.cardId = gridLayoutItemInfo.cardId ?? '';
    screenFaItem.page = gridLayoutItemInfo.page ?? -1;
    screenFaItem.typeId = gridLayoutItemInfo.typeId ?? 0;
    return screenFaItem;
  }

  private static getScreenFaItemByCardItemInfo(cardItemInfo: CardItemInfo, index: number): LauncherScreenFaItem {
    let screenFaItem = new LauncherScreenFaItem();
    screenFaItem.cardName = cardItemInfo.cardName;
    screenFaItem.dimension = CardItemInfo.getCardDimension(cardItemInfo.area);
    screenFaItem.bundleName = cardItemInfo.bundleName;
    screenFaItem.moduleName = cardItemInfo.moduleName;
    screenFaItem.abilityName = cardItemInfo.abilityName;
    screenFaItem.cardId = cardItemInfo.cardId;
    screenFaItem.page = cardItemInfo.page ?? -1;
    screenFaItem.typeId = cardItemInfo.typeId;
    screenFaItem.indexInStack = index;
    return screenFaItem;
  }

  private static getScreenItem(folderAppItemInfo: FolderAppItemInfo): LauncherScreenItem {
    let screenItem = new LauncherScreenItem();
    screenItem.bundleName = folderAppItemInfo.bundleName;
    screenItem.moduleName = folderAppItemInfo.moduleName ?? '';
    screenItem.abilityName = folderAppItemInfo.abilityName;
    screenItem.typeId = folderAppItemInfo.typeId ?? 0;
    screenItem.appIndex = folderAppItemInfo.appIndex ?? 0;
    return screenItem;
  }
}