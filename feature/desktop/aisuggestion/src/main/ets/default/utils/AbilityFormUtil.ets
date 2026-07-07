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
import bundleManager from '@ohos.bundle.bundleManager';
import display from '@ohos.display';
import { LinkedList } from '@kit.ArkTS';
import { ObjectCopyUtil, } from '@ohos/componenthelper';
import { CheckEmptyUtils, LogDomain, LogHelper, } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { ResUtils, SCBScreenSessionManager } from '@ohos/windowscene';
import {
  AppIconModel,
  BundleConstants,
  CardItemInfo,
  CommonConstants,
  FormLayoutCacheManager,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
  PageDesktopModel,
} from '@ohos/launchercommon';
import type { FormStackItemInfo } from '@ohos/formstack/src/main/ets/common/FormStackItemInfo';
import { FormStackUtil } from '@ohos/formstack/src/main/ets/common/FormStackUtil';
import { ExtraData } from '@ohos/launchercommon/src/main/ets/aisuggestion/ExtraData';
import AiSuggestionUpdateConstants from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUpdateConstants';
import { AiSuggestionConstants } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';
import type { InputFaInfo } from '../bean/InputFaInfo';
import { LauncherCardInfo } from '../bean/LauncherCardInfo';
import { LauncherFormDistribution } from '../bean/LauncherFormDistribution';
import { ScreenDisplayStatus } from '../constants/ScreenDisplayStatus';
import { AiSuggestionFormManager } from '../manager/AiSuggestionFormManager';
import formHost from '@ohos.app.form.formHost';
import { PortfolioInfoDisplayMode } from '../constants/PortfolioInfoDisplayMode';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';
import { AiSuggestionUtil } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUtil';
import { PortfolioInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/PortfolioInfo';

const TAG: string = 'AbilityFormUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 卡片工具
 *
 * @since 2023-08-11
 */
export class AbilityFormUtil {
  /**
   * 创建语音助手建议卡片
   *
   * @param baseLayoutInfo 基准卡片信息
   * @returns 基于基准卡片创建的语音助手建议卡片
   */
  public static createVoiceSuggestionCard(baseLayoutInfo: GridLayoutItemInfo | undefined): GridLayoutItemInfo {
    if (CheckEmptyUtils.isEmpty(baseLayoutInfo)) {
      log.showWarn('createVoiceSuggestionCard baseLayoutInfo is invalid');
      return new GridLayoutItemInfo();
    }

    const voiceSuggestionCard = ObjectCopyUtil.deepClone(baseLayoutInfo, new GridLayoutItemInfo());
    if (!voiceSuggestionCard) {
      log.showWarn('createVoiceSuggestionCard voiceSuggestionCard is invalid');
      return new GridLayoutItemInfo();
    }
    voiceSuggestionCard.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
    voiceSuggestionCard.moduleName = BundleConstants.AI_SUGGESTION_MODULE;
    voiceSuggestionCard.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
    voiceSuggestionCard.cardDimension = CardItemInfo.getCardDimension(baseLayoutInfo?.area);
    if (voiceSuggestionCard.cardDimension === CommonConstants.CARD_DIMENSION_2x2) {
      voiceSuggestionCard.cardName = BundleConstants.AI_SUGGESTION_MIN_CARD;
    } else if (voiceSuggestionCard.cardDimension === CommonConstants.CARD_DIMENSION_2x4) {
      voiceSuggestionCard.cardName = BundleConstants.AI_SUGGESTION_MED_CARD;
    } else if (voiceSuggestionCard.cardDimension === CommonConstants.CARD_DIMENSION_4x4) {
      voiceSuggestionCard.cardName = BundleConstants.AI_SUGGESTION_MAX_CARD;
    } else {
      log.showWarn('createVoiceSuggestionCard unknown card dimension');
    }
    return voiceSuggestionCard;
  }

  /**
   * 创建卡片
   *
   * @param baseLayoutInfo 基准卡片信息
   * @param createCard 创建的卡片信息
   * @returns 基于基准卡片创建的卡片
   */
  public static createCard(baseLayoutInfo: GridLayoutItemInfo | undefined,
    createCard: LauncherRecItem): GridLayoutItemInfo {
    if (CheckEmptyUtils.isEmpty(baseLayoutInfo) || CheckEmptyUtils.isEmpty(createCard)) {
      log.showWarn('createCard baseLayoutInfo or createCard is invalid');
      return new GridLayoutItemInfo();
    }

    const cloneCard = ObjectCopyUtil.deepClone(baseLayoutInfo, new GridLayoutItemInfo());
    if (!cloneCard) {
      log.showWarn('createCard cloneCard is invalid');
      return new GridLayoutItemInfo();
    }
    cloneCard.bundleName = createCard.bundleName;
    cloneCard.moduleName = createCard.moduleName;
    cloneCard.abilityName = createCard.abilityName;
    cloneCard.cardDimension = createCard.dimension;
    cloneCard.cardName = createCard.formName;
    cloneCard.cardId = undefined;
    return cloneCard;
  }

  /**
   * 卡片是否可见
   *
   * @param cardId 卡片ID
   * @returns true-卡片可见
   */
  static isAbilityFormVisible(cardId: string): boolean {
    const currentPage: number = PageDesktopModel.getInstance().getPageIndex();
    // 如果是堆叠中的卡片，则判断是否置顶且当前页可见
    const stackItemInfo: FormStackItemInfo | undefined = AbilityFormUtil.getCardBelongFormStack(cardId);
    if (!FormStackUtil.isFormStackLayoutItemInvalid(stackItemInfo)) {
      let stackItemList: CardItemInfo[] = stackItemInfo?.layoutInfo[0] ?? [];
      let stackTopCard: CardItemInfo = stackItemList[stackItemList.length - 1];
      return stackItemInfo?.page === currentPage && stackTopCard.cardId === cardId;
    }
    // 如果是单张卡片，则判断是否当前页可见
    const cardItemInfo: GridLayoutItemInfo | undefined =
      FormLayoutCacheManager.getInstance().selectGridLayoutItemByCardId(cardId);
    return cardItemInfo?.page === currentPage;
  }

  /**
   * 获取当前屏可见的语音助手卡片集合
   *
   * @returns 语音助手卡片集合
   */
  static getVisibleVoiceList(): GridLayoutItemInfo[] {
    let pageIndex: number = PageDesktopModel.getInstance().getPageIndex();
    const itemList: GridLayoutItemInfo[] =
      LaunchLayoutCacheManager.getInstance().selectGridLayoutItemsByPage(pageIndex);
    if (!itemList || itemList.length === 0) {
      log.showInfo('no items in current desktop');
      return [];
    }
    let visibleVoiceList: GridLayoutItemInfo[] = [];
    itemList.forEach(item => {
      if (item.typeId === CommonConstants.TYPE_CARD &&
      AiSuggestionUtil.isVoiceAbilityForm(item.bundleName, item.abilityName)) {
        visibleVoiceList.push(item);
      }
      if (item.typeId === CommonConstants.TYPE_FORM_STACK) {
        if (CheckEmptyUtils.isEmptyArr(item.layoutInfo?.[0])) {
          log.showWarn(`formStack is empty, id: ${item.formStackId}}`);
          return;
        }
        const stackItemList: GridLayoutItemInfo[] = item.layoutInfo?.[0] ?? [];
        let stackTopCard: GridLayoutItemInfo = stackItemList[stackItemList.length - 1];
        if (stackTopCard.typeId === CommonConstants.TYPE_CARD &&
        AiSuggestionUtil.isVoiceAbilityForm(stackTopCard.bundleName, stackTopCard.abilityName)) {
          visibleVoiceList.push(stackTopCard);
        }
      }
    });
    return visibleVoiceList;
  }

  /**
   * 根据卡片ID找母卡信息
   *
   * @param cardId 卡片ID
   * @returns 母卡信息
   */
  static findParentFormByFormId(cardId: string | undefined): LauncherCardInfo | undefined {
    return AiSuggestionFormManager.getInstance().getCardInfo(cardId);
  }

  /**
   * 获取当前屏幕显示状态（竖屏、横屏、折叠屏展开）
   *
   * 'portrait' | 'landscape' | 'expand'
   */
  public static getScreenDisplayStatus(): string {
    if (AbilityFormUtil.isExpand()) {
      return ScreenDisplayStatus.EXPAND;
    }
    return AbilityFormUtil.isPortrait() ? ScreenDisplayStatus.PORTRAIT : ScreenDisplayStatus.LANDSCAPE;
  }

  /**
   * 是否展开
   *
   * @returns true-折叠屏展开
   */
  public static isExpand(): boolean {
    return SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
  }

  /**
   * 是否竖屏
   *
   * @returns true-竖屏，false-横屏
   */
  public static isPortrait(): boolean {
    // 手机产品的语音助手建议仅折叠屏展开态存在横屏
    if (DeviceHelper.isPhone()) {
      return true;
    }
    let portrait: boolean = false;
    try {
      const orientation: display.Orientation = display.getDefaultDisplaySync().orientation;
      portrait = orientation === display.Orientation.PORTRAIT || orientation === display.Orientation.PORTRAIT_INVERTED;
    } catch (err) {
      log.error('isPortrait getDefaultDisplaySync failed, ', err);
    }
    return portrait;
  }

  public static async getVersionName(bundleName: string): Promise<string> {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      return '';
    }
    let bundleInfo = await bundleManager.getBundleInfo(bundleName, bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT)
      .catch(() => {
        log.showError('get bundleInfo error');
        return null;
      });
    if (CheckEmptyUtils.isEmpty(bundleInfo)) {
      return '';
    }
    return bundleInfo?.versionName ?? '';
  }

  /**
   * 获取内外屏堆叠列表
   *
   * @return 堆叠列表
   */
  public static getAllFormStackList(): GridLayoutItemInfo[] {
    const allFormStacks: GridLayoutItemInfo[] = FormLayoutCacheManager.getInstance()
      .selectGridLayoutItemsByType(CommonConstants.TYPE_FORM_STACK, false);
    return allFormStacks;
  }

  /**
   * 获取卡片所属的堆叠组
   *
   * @param cardId 卡片id
   * @returns 堆叠组信息
   */
  public static getCardBelongFormStack(cardId: string | undefined): FormStackItemInfo | undefined {
    if (AbilityFormUtil.isCardIdInvalid(cardId)) {
      log.showWarn('getCardBelongFormStack cardId is empty');
      return undefined;
    }
    let formStackList: GridLayoutItemInfo[] = AbilityFormUtil.getAllFormStackList();
    if (formStackList.length === 0) {
      return undefined;
    }
    for (let i = 0; i < formStackList.length; i++) {
      let item = formStackList[i];
      let formStackItem: FormStackItemInfo = item as Object as FormStackItemInfo;
      if (CheckEmptyUtils.isEmpty(formStackItem.layoutInfo) || CheckEmptyUtils.isEmptyArr(formStackItem.layoutInfo)) {
        continue;
      }
      let cardList = formStackItem.layoutInfo[0].filter(cardInfo => cardInfo.cardId === cardId);
      if (cardList.length > 0) {
        return formStackItem;
      }
    }
    return undefined;
  }

  /**
   * 获取桌面上所有的语音助手建议卡片（包括内外屏和堆叠里面的）
   *
   * @returns 语音助手建议卡片集合
   */
  public static getAllAiSuggestionItems(): GridLayoutItemInfo[] {
    const allSuggestionItems: GridLayoutItemInfo[] =
      FormLayoutCacheManager.getInstance().selectAllAiSuggestionItems(false);
    return allSuggestionItems;
  }

  /**
   * 获取语音助手建议所在屏
   *
   * @param appGridInfo 新的桌面数据
   * @returns 语音助手建议所在屏
   */
  public static getVoiceLayoutPages(appGridInfo: [GridLayoutItemInfo[]]): number[] {
    let suggestionPages: Set<number> = new Set();
    for (let i = 0; i < appGridInfo.length; i++) {
      let itemInfos: GridLayoutItemInfo[] = appGridInfo[i];
      itemInfos.filter(info => info.typeId === CommonConstants.TYPE_CARD &&
      AiSuggestionUtil.isVoiceAbilityForm(info.bundleName, info.abilityName))
        .forEach(info => suggestionPages.add(info.page ?? 0));

      itemInfos.filter(info => info.typeId === CommonConstants.TYPE_FORM_STACK &&
      AbilityFormUtil.isFormStackContainVoiceCard(info))
        .filter(info => info.page !== undefined)
        .forEach(info => suggestionPages.add(info.page ?? -1));
    }
    return Array.from(suggestionPages);
  }

  public static isDefaultCard(recItem: LauncherRecItem): boolean {
    return AiSuggestionUtil.isVoiceAbilityForm(recItem.bundleName, recItem.abilityName);
  }

  /**
   * 根据卡片id获取语音助手建议的卡片信息
   *
   * @param cardId 卡片id
   * @returns 语音助手建议卡片信息
   */
  public static getAiSuggestionItemByCardId(cardId: string): GridLayoutItemInfo | undefined {
    return AbilityFormUtil.getAllAiSuggestionItems().find(item => {
      return item.cardId === cardId;
    });
  }

  /**
   * 根据堆叠组ID 和 场景卡ID 获取堆叠组中的卡片信息
   *
   * @param stackId 堆叠组ID
   * @param portfolioId 场景卡ID
   * @returns 卡片信息
   */
  public static getItemInfoFromStackByPortfolioId(stackId: string,
    portfolioId: string): GridLayoutItemInfo | undefined {
    const cardList = AbilityFormUtil.getFormStackInfoByFormStackId(stackId);
    if (CheckEmptyUtils.isEmptyArr(cardList)) {
      return undefined;
    }
    let cardListStr = cardList.map(cardInfo => cardInfo.extend1).toString();
    log.showInfo(`getItemInfoFromStackByPortfolioId stackId: ${stackId}, cardListStr: ${cardListStr}`);
    return cardList.find(itemInfo => ExtraData.getPortfolioId(itemInfo) === portfolioId);
  }

  /**
   * 获取桌面上的特定卡片（包括堆叠里面的）
   *
   * @returns 特定卡片集合
   */
  static getFormDistributionFromCache(inputFormInfo: InputFaInfo,
    isOuter?: boolean): Promise<LauncherFormDistribution[]> {
    let formDistributionItems: LauncherFormDistribution[] = [];
    const allCardsAndFormStack: GridLayoutItemInfo[] =
      FormLayoutCacheManager.getInstance().selectAllFormsAndFormStack(isOuter);
    for (let i = 0; i < allCardsAndFormStack.length; i++) {
      let info = allCardsAndFormStack[i];
      if (info.typeId === CommonConstants.TYPE_CARD && AbilityFormUtil.formInfoIsMatch(inputFormInfo, info)) {
        formDistributionItems.push(LauncherFormDistribution.convert(info));
      } else if (info.typeId === CommonConstants.TYPE_FORM_STACK) {
        let distributions: LauncherFormDistribution[] = AbilityFormUtil.getItemFromFormStack(inputFormInfo, info);
        if (!CheckEmptyUtils.isEmptyArr(distributions)) {
          formDistributionItems.push(...distributions);
        }
      }
    }
    return Promise.resolve(formDistributionItems);
  }

  private static getItemFromFormStack(inputFormInfo: InputFaInfo,
    info: GridLayoutItemInfo): LauncherFormDistribution[] {
    let formDistributionItems: LauncherFormDistribution[] = [];
    let formStackItemInfo = info as object as FormStackItemInfo;
    if (FormStackUtil.isFormStackLayoutItemInvalid(formStackItemInfo)) {
      return formDistributionItems;
    }
    let formStackItemList = formStackItemInfo.layoutInfo[0];
    for (let i = 0; i < formStackItemList.length; i++) {
      let cardItemInfo = formStackItemList[i];
      let itemIndex = i;
      if (!AbilityFormUtil.formInfoIsMatch(inputFormInfo, cardItemInfo as object as GridLayoutItemInfo)) {
        continue;
      }
      let distributionItem = LauncherFormDistribution.convert(cardItemInfo as object as GridLayoutItemInfo);
      distributionItem.cellX = formStackItemInfo.column;
      distributionItem.cellY = formStackItemInfo.row;
      distributionItem.screenIndex = formStackItemInfo.page;
      distributionItem.stackInfo = {
        stackId: formStackItemInfo.formStackId ?? '',
        itemCount: formStackItemList.length,
        parentFormIndex: itemIndex,
      };
      formDistributionItems.push(distributionItem);
    }
    return formDistributionItems;
  }

  /**
   * 判断堆叠里面是否有语音助手建议卡片
   *
   * @param gridlayoutInfo 堆叠组
   * @returns true:包含
   */
  public static isFormStackContainVoiceCard(gridlayoutInfo: GridLayoutItemInfo | FormStackItemInfo): boolean {
    if (!gridlayoutInfo) {
      log.warn('isFormStackContainVoiceCard gridlayoutInfo invalid');
      return false;
    }
    let formStackItem: FormStackItemInfo = gridlayoutInfo as Object as FormStackItemInfo;
    if (CheckEmptyUtils.isEmptyArr(formStackItem.layoutInfo)) {
      return false;
    }
    let suggestionItems =
      formStackItem.layoutInfo[0].filter(gridlayoutInfo => gridlayoutInfo.typeId === CommonConstants.TYPE_CARD &&
      AiSuggestionUtil.isVoiceAbilityForm(gridlayoutInfo.bundleName, gridlayoutInfo.abilityName));
    return suggestionItems.length > 0;
  }

  public static getDefaultNameOfAiSuggestion(): string {
    return ResUtils.getInnerString($r('app.string.aisuggestion_app_name'));
  }

  private static formInfoIsMatch(inputFaInfo: InputFaInfo, itemInfo: GridLayoutItemInfo): boolean {
    if (inputFaInfo.bundleName && inputFaInfo.bundleName !== itemInfo.bundleName) {
      return false;
    }
    if (inputFaInfo.moduleName && inputFaInfo.moduleName !== itemInfo.moduleName) {
      return false;
    }
    if (inputFaInfo.formName && inputFaInfo.formName !== itemInfo.cardName) {
      return false;
    }
    if (inputFaInfo.abilityName && inputFaInfo.abilityName !== itemInfo.abilityName) {
      return false;
    }
    if (inputFaInfo.dimension) {
      if (!itemInfo.area) {
        return false;
      }
      const dimensions: number[] = CardItemInfo.getCardSize(inputFaInfo.dimension);
      const width: number = dimensions[0];
      const height: number = dimensions[1];
      if (itemInfo.area[0] !== width && itemInfo.area[1] !== height) {
        return false;
      }
    }
    return true;
  }

  private static getAppIconKeyName(recItems: LauncherRecItem, cardId: string | undefined): string {
    return AppIconModel.getInstance().getIconId(recItems, cardId);
  }

  /**
   * 存储卡片内容中的服务ID
   *
   * @param cardId
   * @param recItems
   */
  static setStorageForCompanion(cardId: string | undefined, recItems: LauncherRecItem[]): void {
    if (AbilityFormUtil.isCardIdInvalid(cardId) || CheckEmptyUtils.isEmptyArr(recItems)) {
      log.showError('setStorageForCompanion cardId or recItems is empty');
      return;
    }
    const oldIconIdList: string[] = (GlobalContext.getInstance().getObject('AiSuggestionSubItems') as string[]) ?? [];
    let iconIdList = oldIconIdList.filter((value) => {
      let arr: string[] = value.split('_');
      return arr[arr.length - 1] !== cardId;
    });
    recItems.forEach((value) => {
      if (value.itemType === AiSuggestionConstants.TYPE_APP) {
        iconIdList.push(AbilityFormUtil.getAppIconKeyName(value, cardId));
      } else if (value.itemType === AiSuggestionConstants.TYPE_APP_GROUP) {
        value.subLauncherRecItems.forEach((subRecItem) => {
          iconIdList.push(AbilityFormUtil.getAppIconKeyName(subRecItem, cardId));
        });
      }
    });
    GlobalContext.getInstance().setObject('AiSuggestionSubItems', iconIdList);
  }

  public static getFormStackInfoByFormStackId(formStackId: string): GridLayoutItemInfo[] {
    if (CheckEmptyUtils.checkStrIsEmpty(formStackId)) {
      return [];
    }
    let formStackInfo: GridLayoutItemInfo[] = AbilityFormUtil.getAllFormStackList().filter(item => item?.formStackId ===
      formStackId);
    return formStackInfo?.[0]?.layoutInfo?.[0] ?? [];
  }

  /**
   * 判断是否是2x2卡片
   *
   * @param item
   * @returns
   */
  static is2x2Form(item: GridLayoutItemInfo | undefined): boolean {
    return CheckEmptyUtils.isEmpty(item) ? false : item?.cardDimension === CommonConstants.CARD_DIMENSION_2x2;
  }

  /**
   * 判断是否是2x4卡片
   *
   * @param item
   * @returns
   */
  static is2x4Form(item: GridLayoutItemInfo | undefined): boolean {
    return CheckEmptyUtils.isEmpty(item) ? false : item?.cardDimension === CommonConstants.CARD_DIMENSION_2x4;
  }

  /**
   * 判断是否是4x4卡片
   *
   * @param item
   * @returns
   */
  static is4x4Form(item: GridLayoutItemInfo | undefined): boolean {
    return CheckEmptyUtils.isEmpty(item) ? false : item?.cardDimension === CommonConstants.CARD_DIMENSION_4x4;
  }

  /**
   * 添加参数
   *
   * @param jsonContent 添加的内容
   * @param parameters 添加的对象
   */
  public static appendParams(jsonContent: string, parameters: Record<string, Object>): void {
    if (CheckEmptyUtils.checkStrIsEmpty(jsonContent) || !parameters) {
      return;
    }
    try {
      const obj: Object = JSON.parse(jsonContent);
      ObjectCopyUtil.deepClone(obj, parameters);
    } catch (err) {
      log.showError(TAG, 'appendParams error');
    }
  }

  /**
   * 获取当前页操作目标
   * @returns operateCommandIds 见BaseCommand中的commandId
   */
  public static getCurrentPageTargets(): string[] {
    let pageIndex: number = PageDesktopModel.getInstance().getPageIndex();
    const itemList: GridLayoutItemInfo[] =
      LaunchLayoutCacheManager.getInstance().selectGridLayoutItemsByPage(pageIndex);
    let visibleCommandIds: string[] = [];
    itemList.forEach(item => {
      if (item.typeId === CommonConstants.TYPE_CARD &&
      AiSuggestionUtil.isVoiceAbilityForm(item.bundleName, item.abilityName)) {
        visibleCommandIds.push(String(item.cardId));
      } else if (item.typeId === CommonConstants.TYPE_FORM_STACK) {
        if (CheckEmptyUtils.isEmptyArr(item.layoutInfo?.[0])) {
          log.showWarn(`formStack is empty, id: ${item.formStackId}`);
          return;
        }
        if (AbilityFormUtil.isFormStackContainVoiceCard(item)) {
          visibleCommandIds.push(String(item.formStackId));
        }
      } else {
      }
    });
    return visibleCommandIds;
  }

  /**
   * 获取当前屏和相邻屏的操作目标
   * @param pageIndex 屏幕索引
   * @returns 当前屏和相邻屏的操作目标
   */
  public static getTargets(pageIndex: number): string[] {
    let operateCommandIds: LinkedList<string> = new LinkedList<string>();
    const itemList: GridLayoutItemInfo[] =
      LaunchLayoutCacheManager.getInstance().selectGridLayoutItemsByPage(pageIndex);
    if (CheckEmptyUtils.isEmptyArr(itemList)) {
      return [];
    }

    itemList.forEach(item => {
      if (item.typeId === CommonConstants.TYPE_FORM_STACK) {
        if (CheckEmptyUtils.isEmptyArr(item.layoutInfo)) {
          log.showWarn(`formStack is empty, id: ${item.formStackId}`);
          return;
        }
        if (AbilityFormUtil.isFormStackContainVoiceCard(item)) {
          // 先找到堆叠
          operateCommandIds.addFirst(String(item.formStackId));
        }
        return;
      }
      if (item.typeId === CommonConstants.TYPE_CARD &&
      AiSuggestionUtil.isVoiceAbilityForm(item.bundleName, item.abilityName)) {
        // 再找卡片
        operateCommandIds.add(String(item.cardId));
      }
    });
    return operateCommandIds.convertToArray();
  }

  static isAddPortfolioCardToFormStack(extraData: ExtraData): boolean {
    return !CheckEmptyUtils.isEmpty(extraData) &&
      (extraData.commandType === AiSuggestionUpdateConstants.CommandType.CREATE_FORM_STACK ||
        extraData.commandType === AiSuggestionUpdateConstants.CommandType.ADD_CARD_TO_STACK
      );
  }

  public static isCardIdInvalid(cardId: string | undefined): boolean {
    return !cardId || CheckEmptyUtils.checkStrIsEmpty(cardId) || cardId === '0';
  }

  /**
   * 通知子卡的可见性
   *
   * @param visible true 可见
   * @param cardId 语音助手建议卡片ID
   */
  public static notifyVisibleChange(visible: boolean, cardId: string | undefined): void {
    AiSuggestionFormManager.getInstance().setFormVisible(cardId, visible);
    const cardInfo = AiSuggestionFormManager.getInstance().getCardInfo(cardId);
    const displayCardInfo = LauncherCardInfo.getDisplayCardInfo(cardInfo);
    const ids = displayCardInfo?.recItems?.filter(recItem => {
      return recItem.itemType === CommonConstants.TYPE_CARD && recItem.cardId;
    }).map(recItem => recItem.cardId);
    if (CheckEmptyUtils.isEmptyArr(ids)) {
      return;
    }
    AbilityFormUtil.formHostNotifyVisibleChange(cardId, visible, ids ?? []);
  }

  public static formHostNotifyVisibleChange(cardId: string | undefined, visible: boolean, cardIds: string[]): void {
    log.showInfo(`formHostNotifyVisibleChange visible: ${visible}, parentCardId: ${cardId}, subCardIds: ${cardIds}`);
    try {
      if (visible) {
        formHost.notifyVisibleForms(cardIds).catch((error: Error) => {
          log.error('formHostNotifyVisibleChange, error:', error);
        });
      } else {
        formHost.notifyInvisibleForms(cardIds).catch((error: Error) => {
          log.error('formHostNotifyVisibleChange, error:', error);
        });
      }
    } catch (error) {
      log.error('formHostNotifyVisibleChange fail, catch err:', error);
    }
  }

  /**
   * 判断是否需要更新卡片ID
   *
   * @param formItem 卡片信息
   * @returns true 需要更新
   */
  public static isUpdateFormId(formItem: GridLayoutItemInfo): boolean {
    let isUpdateFormId: boolean = false;
    if (AbilityFormUtil.isCardIdInvalid(formItem?.cardId ?? '')) {
      // 卡片ID为空的时候需要更新卡片ID
      isUpdateFormId = true;
    }
    return isUpdateFormId;
  }

  /**
   * 是否是同一卡片
   *
   * @param recItem
   * @param gridLayoutItemInfo
   * @returns 是true
   */
  public static isSameForm(recItem: LauncherRecItem, gridLayoutItemInfo: GridLayoutItemInfo): boolean {
    if (!recItem || !gridLayoutItemInfo) {
      log.showWarn('isSameForm recItem or gridLayoutItemInfo isEmpty');
      return false;
    }

    return recItem.bundleName === gridLayoutItemInfo.bundleName &&
      recItem.abilityName === gridLayoutItemInfo.abilityName &&
      recItem.formName === gridLayoutItemInfo.cardName &&
      recItem.moduleName === gridLayoutItemInfo.moduleName &&
      recItem.dimension === gridLayoutItemInfo.cardDimension;
  }

  /**
   * 判断单张推荐内容铺满了整个卡片
   *
   * @param recItems 推荐内容
   * @returns true 推荐的卡片大小和主卡大小一样
   */
  public static isFullFill(recItems: LauncherRecItem[]): boolean {
    if (!recItems) {
      log.showError('isFullFill error');
      return false;
    }
    if (recItems.length !== 1) {
      return false;
    }
    return recItems[0].rowStart === 0 && recItems[0].columnStart === 0;
  }

  /**
   * 判断是否展开状态
   *
   * @param foldStatus 屏幕状态
   * @returns true 展开状态
   */
  public static isFoldScreenExpand(foldStatus: display.FoldStatus): boolean {
    return foldStatus !== display.FoldStatus.FOLD_STATUS_FOLDED;
  }

  /**
   * 设置状态栏已展示
   *
   * @param portfolioInfo 场景信息
   * @param cardDimension 卡片尺寸
   */
  public static updateDisplayMode(portfolioInfo: PortfolioInfo | undefined, cardDimension: number | undefined): void {
    if (portfolioInfo) {
      portfolioInfo.displayMode = PortfolioInfoDisplayMode.DISPLAY_MODE_NOT_EXIST;
      AiSuggestionFormManager.getInstance().setExposeStatus(cardDimension, portfolioInfo.portfolioId);
    }
  }

  /**
   * 根据时间戳随机生成id
   *
   * @returns
   */
  public static generateCardId(): string {
    const randomId = String(Math.round(Math.random() * Date.now()));
    if (randomId.length > 10) {
      return randomId.substring(0, 10);
    }
    return randomId;
  }
}