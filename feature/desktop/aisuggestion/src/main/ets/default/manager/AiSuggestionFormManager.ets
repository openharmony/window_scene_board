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

import { BusinessType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import {
  DeviceHelper,
  GlobalContext,
  localEventManager,
  ResourceManager,
  settingsDataManager
} from '@ohos/frameworkwrapper';
import { CheckEmptyUtils, JsonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import {
  CloseAppManager,
  EventConstants,
  FormLayoutCacheManager,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
  SceneMsgEnum,
} from '@ohos/launchercommon';
import {
  CommonConstants,
  FormCommonUtil,
  FormModel,
  RdbStoreManager,
} from '@ohos/launchercommon';
import { CardNodeControllerManager } from '@ohos/launchercommon/Index';
import { CardNodeController } from '@ohos/launchercommon/src/main/ets/buildernode/CardNodeController';
import { ExtraData } from '@ohos/launchercommon/src/main/ets/aisuggestion/ExtraData';
import { AiSuggestionConstants } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';
import { LauncherCardInfo } from '../bean/LauncherCardInfo';
import { AiSuggestionEventReporter } from '../donate/AiSuggestionEventReporter';
import { AbilityFormUtil } from '../utils/AbilityFormUtil';
import { CommonUtil } from '../utils/CommonUtil';
import AiSuggestionActionManager from './AiSuggestionActionManager';
import { ServiceValidator } from '../utils/ServiceValidator';
import lazy {
  outerAddAppIconManager
} from '@ohos/launchercommon/src/main/ets/manager/OuterAddAppIconManager';
import { AiSuggestionEventName } from '../constants/AiSuggestionEventName';
import { image } from '@kit.ImageKit';
import { componentSnapshot } from '@kit.ArkUI';
import { AiSuggestionDataHelper } from '../helper/AiSuggestionDataHelper';
import { AiSuggestionRdbHelper } from '../helper/AiSuggestionRdbHelper';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';

const TAG = 'AiSuggestionFormManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);
const REQUEST_DELAY: number = 200;
const CLEAR_NODE_CACHE_DELAY = 1000;

/**
 * 语音助手建议卡片管理类
 *
 * @since 2025-03-17
 */
export class AiSuggestionFormManager {
  private static instance: AiSuggestionFormManager;
  private featureVersion: number = 0;
  private snapComponentId: string = '';
  private snapshotImage?: image.PixelMap;
  private formVisible: Map<string, boolean> = new Map();
  /**
   * card info for ai suggestion. key:cardId
   */
  private cardInfoCacheMap: Map<string, LauncherCardInfo> = new Map();

  /**
   * card id set cache for ai suggestion.
   */
  private cardIdCacheSet: Set<string> = new Set();
  private debounceRequestData = CommonUtil.debounce<GridLayoutItemInfo>(this.requestData, REQUEST_DELAY);

  private requestData(formItem: GridLayoutItemInfo): void {
    AiSuggestionActionManager.getInstance().requestData(formItem);
  }

  private constructor() {
  }

  /**
   * get AiSuggestionFormManager instance
   *
   * @return AiSuggestionFormManager instance
   */
  static getInstance(): AiSuggestionFormManager {
    if (AiSuggestionFormManager.instance == null) {
      RdbStoreManager.getInstance().initVoiceInfoTable();
      AiSuggestionFormManager.instance = new AiSuggestionFormManager();
    }
    return AiSuggestionFormManager.instance;
  }

  /**
   * init card info from RDB
   *
   * @param cardId card id
   */
  public async initVoiceCardInfo(formItem: GridLayoutItemInfo, isCreatingCard?: boolean): Promise<void> {
    if (!formItem.cardId) {
      log.showWarn('initVoiceCardInfo failed, cardId:%{public}s', formItem.cardId);
      return;
    }
    if (isCreatingCard) { // 创建卡片
      this.showDefaultCard(formItem, isCreatingCard);
      this.debounceRequestData(formItem);
      return;
    }
    let cardId: string = formItem.cardId;
    let cardInfo: LauncherCardInfo | undefined = this.cardInfoCacheMap.get(cardId);
    if (!cardInfo) {
      // 目的是使重启前的卡片id能够正常释放，若需要更早加载到缓存，需要解决升级场景会出现图标显示异常或者内部服务卡片无法加载的情况
      let tempStr: string = await RdbStoreManager.getInstance().queryVoiceCardInfo(cardId);
      if (!CheckEmptyUtils.checkStrIsEmpty(tempStr)) {
        try {
          cardInfo = JSON.parse(tempStr) as LauncherCardInfo;
          this.cardInfoCacheMap.set(cardId, cardInfo);
        } catch (err) {
          log.error('initVoiceCardInfo query voice card info from rdb failed', err);
          // 数据异常，清除缓存数据
          RdbStoreManager.getInstance().deleteVoiceCardInfoByCardId(cardId);
        }
      }
    }
    if (await ServiceValidator.isCardInfoValid(cardInfo)) {
      this.updateCard(cardId, cardInfo);
    } else {
      this.showDefaultCard(formItem);
      this.debounceRequestData(formItem);
    }
  }

  public updateVoiceCardId(oldVoiceCardId: string | undefined, newVoiceCardId: string): void {
    if (AbilityFormUtil.isCardIdInvalid(oldVoiceCardId)) {
      log.showWarn(`updateVoiceCardId oldCardId [${oldVoiceCardId}] is invalid, newCardId=${newVoiceCardId}`);
      return;
    }
    const cardInfo: LauncherCardInfo | undefined = this.getCardInfo(oldVoiceCardId);
    if (oldVoiceCardId) {
      this.cardInfoCacheMap.delete(oldVoiceCardId);
    }
    if (cardInfo) {
      this.cardInfoCacheMap.set(newVoiceCardId, cardInfo);
    }
    RdbStoreManager.getInstance().deleteVoiceCardInfoByCardId(oldVoiceCardId);
    AiSuggestionRdbHelper.updateAiSuggestionCardRdbInfo(newVoiceCardId);
  }

  /**
   * 显示默认卡片，引导卡未复用母卡ID，刷新服务时引导卡ID需要释放
   * 若最终复用母卡ID，释放引导卡ID时有做是否复用母卡的判断
   * @param formItem 卡片信息
   */
  public showDefaultCard(formItem: GridLayoutItemInfo, isCreatingCard?: boolean): void {
    let launcherCardInfo: LauncherCardInfo = AiSuggestionDataHelper.getDefaultLaunchCardInfo(formItem,
      isCreatingCard ? formItem.cardId : undefined);
    log.showError(`show default card cardId:${formItem?.cardId}`);
    this.updateCardInfo(formItem.cardId, launcherCardInfo);
  }

  /**
   * 刷新当前卡片
   *
   * @param cardId 卡片ID
   */
  refreshCardInfo(cardId: string | undefined): void {
    if (!cardId) {
      log.showError('refreshCardInfo invalid cardId');
      return;
    }
    if (AbilityFormUtil.isCardIdInvalid(cardId)) {
      log.showWarn('refreshCardInfo id is invalid');
      return;
    }
    let cardInfo: LauncherCardInfo | undefined = this.cardInfoCacheMap.get(cardId);
    log.showInfo('refreshCardInfo id %{public}s', cardId);
    this.updateCard(cardId, cardInfo);
  }

  /**
   * get card info by id
   *
   * @param cardId card id
   * @return card info
   */
  getCardInfo(cardId: string | undefined): LauncherCardInfo | undefined {
    if (!cardId) {
      log.showError('getCardInfo invalid cardId');
      return;
    }
    let launcherCardInfo = this.cardInfoCacheMap.get(cardId);
    if (!launcherCardInfo) {
      log.showInfo('cannot get launcherCardInfo of cardId %{public}s, key exists? %{public}s',
        cardId, this.cardInfoCacheMap.has(cardId));
    }
    return launcherCardInfo;
  }

  private setVoiceRectItemCardId(reuseCardIds: Set<string>, item: LauncherRecItem, recItems: LauncherRecItem[]): void {
    if (!recItems || !item) {
      log.showError(`setVoiceRectItemCardId failed, param is invalid, recItems: ${!recItems}, item: ${!item}`);
      return;
    }
    if (!CheckEmptyUtils.checkStrIsEmpty(item.formWantInfo)) {
      log.showDebug(`item serviceId = ${item.serviceId}, formWantInfo = ${item.formWantInfo}`);
    }
    let oldItem = this.findItem(recItems, item);
    if (oldItem) {
      log.showInfo('reuseRectItemCardId serviceId: %{public}s, cardId: %{public}s', oldItem.serviceId, oldItem.cardId);
      item.cardId = oldItem.cardId;
      reuseCardIds.add(item.cardId);
      this.updateSubCardIfNeed(item, oldItem);
    }
  }

  private updateSubCardIfNeed(item: LauncherRecItem, oldItem: LauncherRecItem): void {
    if (!oldItem.cardId) {
      log.showInfo(`updateSubCardIfNeed recItem serviceId: ${oldItem.serviceId} cardId invalid`);
      return;
    }
    if (CheckEmptyUtils.checkStrIsEmpty(item.formWantInfo) && CheckEmptyUtils.checkStrIsEmpty(oldItem.formWantInfo)) {
      log.showInfo('updateSubCardIfNeed recItem serviceId: %{public}s, cardId: %{public}s formWantInfo is empty,' +
        ' no need to update', oldItem.serviceId, oldItem.cardId);
      return;
    }
    if (oldItem.formWantInfo === item.formWantInfo) {
      log.showInfo('updateSubCardIfNeed recItem serviceId: %{public}s, cardId: %{public}s formWantInfo same to before',
        oldItem.serviceId, oldItem.cardId);
      return;
    }
    let params: Record<string, Object> = {};
    params[AiSuggestionConstants.FORM_WANT_INFO] = item.formWantInfo;
    AbilityFormUtil.appendParams(item.formWantInfo, params);
    if (item.recInfo) {
      item.recInfo.parentFormId = item.cardId;
      params[AiSuggestionConstants.REC_INFO] = JsonUtils.toJson(item.recInfo);
    }
    FormCommonUtil.requestFormWithParams(oldItem.cardId.toString(), params);
  }

  private reuseRectItemCardId(reuseCardIds: Set<string>, newCardInfo: LauncherCardInfo,
    oldCardInfo?: LauncherCardInfo): void {
    if (!oldCardInfo) {
      return;
    }
    newCardInfo.portrait?.recItems?.forEach((item) => {
      this.setVoiceRectItemCardId(reuseCardIds, item, oldCardInfo.portrait?.recItems ?? []);
    });

    newCardInfo.landscapeOrExpand?.recItems?.forEach((item) => {
      this.setVoiceRectItemCardId(reuseCardIds, item, oldCardInfo.landscapeOrExpand?.recItems ?? []);
    });
  }

  /**
   * 桌面进程重启时，使用数据库数据更新卡片
   *
   * @param cardId card id
   * @param cardInfo card info
   */
  private updateCard(cardId: string, cardInfo: LauncherCardInfo | undefined): void {
    if (cardInfo) {
      this.setFeatureVersion(cardInfo.featureVersion);
      GlobalContext.getContext()?.eventHub.emit(AiSuggestionEventName.getUpdateCardEventName(cardId), cardInfo);
    }
  }

  /**
   * 用于初始化/云侧更新数据更新
   *
   * @param cardId card id
   * @param cardInfo card info
   */
  updateCardInfo(cardId: string | undefined, cardInfo: LauncherCardInfo): void {
    if (!cardId || !cardInfo) {
      log.showError('updateCardInfo invalid cardId or cardInfo');
      return;
    }
    let cardInfoClone = ObjectCopyUtil.deepClone(cardInfo) as LauncherCardInfo;
    let layoutInfo: GridLayoutItemInfo | undefined = AbilityFormUtil.getAiSuggestionItemByCardId(cardId);
    let portfolioId: string = '';
    if (layoutInfo) {
      portfolioId = ExtraData.getPortfolioId(layoutInfo);
    }
    if (layoutInfo && !CheckEmptyUtils.isEmpty(portfolioId) && portfolioId !== cardInfo.portfolioInfo?.portfolioId) {
      // 场景卡变更，更新数据库
      ExtraData.setPortfolioId(layoutInfo, cardInfo.portfolioInfo?.portfolioId ?? '');
      ExtraData.setCardUniqueTag(layoutInfo, cardInfo.cardUniqueTag);
      log.showWarn('update portfolioId, cardId=%{public}s, container=%{public}d, extend1=%{public}s',
        cardId, layoutInfo.container, layoutInfo.extend1);
      FormModel.getInstance().updateExtend1ByCardId(layoutInfo.extend1, layoutInfo.cardId);
    }

    log.showInfo('updateCardInfo: %{public}s, recId: %{public}s, subRecId: %{public}d', cardId, cardInfo.recId,
      cardInfo.subRecId);
    // 深拷贝后保存LauncherCardInfo数据到缓存和数据库
    let oldLauncherCardInfo: LauncherCardInfo | undefined = this.cardInfoCacheMap.get(cardId);
    // 底层卡片框架会缓存卡片id，因此每次从云侧刷新时，需要查找已创建的卡片id，做布局时直接传入该id，则不需要重新创建卡片。
    const reuseCardIds: Set<string> = new Set();
    this.reuseRectItemCardId(reuseCardIds, cardInfoClone, oldLauncherCardInfo);

    this.cardInfoCacheMap.set(cardId, cardInfoClone);

    AiSuggestionRdbHelper.updateAiSuggestionCardRdbInfo(cardId);
    // 每次云侧更新时，删除不用的card id
    let deleteCardIdList: string[] = this.getDeleteCardIdList(reuseCardIds, oldLauncherCardInfo);
    deleteCardIdList = deleteCardIdList.filter(deleteId => deleteId !== cardId);
    log.showInfo(`updateCardInfo cardId: ${cardId}, deleteCardIdList: ${deleteCardIdList.toString()}`);
    this.updateCard(cardId, cardInfoClone);
    setTimeout(() => {
      deleteCardIdList.forEach(cardId => FormModel.getInstance().deleteFormByFormID(cardId));
    }, AiSuggestionConstants.REFRESH_ANIM_DURATION);
  }

  private getDeleteCardIdList(reuseCardIds: Set<string>, oldLauncherCardInfo: LauncherCardInfo | undefined): string[] {
    let deleteCardIdList: string[] = [];
    oldLauncherCardInfo?.landscapeOrExpand?.recItems?.forEach((item) => {
      this.deleteNotUsedId(reuseCardIds, item, deleteCardIdList);
    });
    oldLauncherCardInfo?.portrait?.recItems?.forEach((item) => {
      this.deleteNotUsedId(reuseCardIds, item, deleteCardIdList);
    });
    return deleteCardIdList;
  }

  private deleteNotUsedId(reuseCardIds: Set<string>, item: LauncherRecItem, deleteCardIdList: string[]): void {
    if (!item.cardId) {
      return;
    }
    const index = Array.from(reuseCardIds).findIndex((cardId) => cardId === item.cardId);
    if (index !== CommonConstants.INVALID_VALUE) {
      this.cacheCardId(item.cardId);
    } else {
      deleteCardIdList.push(item.cardId);
    }
  }

  public cacheCardId(cardId: string): void {
    log.showInfo(`cacheCardId cardId ${cardId}`);
    if (!cardId) {
      return;
    }
    // TODO 各个模块使用card id的地方统一写入到桌面card id总表中，释放的时候统一清理。
    this.cardIdCacheSet.add(cardId);
  }

  /**
   * delete card info and notify refresh component
   *
   * @param cardId card id
   */
  deleteCardInfo(cardId: string): void {
    if (!cardId) {
      log.showWarn('deleteCardInfo id undefined');
      return;
    }
    log.showInfo('deleteCardInfo id %{public}s', cardId);
    GlobalContext.getContext()?.eventHub.emit(AiSuggestionEventName.getDeleteCardEventName(cardId), cardId);
  }

  /**
   * after remove animation, delete card info
   *
   * @param cardId card id
   */
  deleteCardInfoAfterAnimation(cardId: string | undefined): void {
    if (!cardId) {
      log.showWarn('deleteCardInfoAfterAnimation cardId invalid');
      return;
    }
    log.showInfo('after animation, deleteCardInfo id %{public}s', cardId);
    this.deleteForRemoveCard(cardId);
    this.cardInfoCacheMap.delete(cardId);
    this.formVisible.delete(cardId);
    RdbStoreManager.getInstance().deleteVoiceCardInfoByCardId(cardId);
    AiSuggestionEventReporter.getInstance().reportSuggestionFormDelete(cardId, false);
  }

  /**
   * 加载默认卡失败，移除语音助手建议
   *
   * @param formItem 卡片
   * @param isOuter 是否为外屏
   */
  public acquireDefaultCardError(formItem: GridLayoutItemInfo | undefined, isOuter?: boolean): void {
    if (!formItem) {
      log.showWarn('acquireDefaultCardError formItem invalid');
      return;
    }
    this.deleteFormByPosition(formItem, isOuter);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, false);

    this.deleteCardInfoAfterAnimation(formItem.cardId);
  }

  /**
   * 根据卡片位置删除卡片
   * @param itemInfo 卡片信息
   * @param isOuter 是否是外屏卡片
   */
  private deleteFormByPosition(itemInfo: GridLayoutItemInfo, isOuter?: boolean): void {
    if (CheckEmptyUtils.isEmpty(itemInfo)) {
      log.showError('deleteFormByPosition invalid parameter');
      return;
    }
    log.showWarn(`deleteFormByPosition, page: ${itemInfo.page}, row: ${itemInfo.row}, column: ${itemInfo.column}` +
      `, isOuter: ${isOuter}`);
    let cardInLayout: GridLayoutItemInfo | undefined =
      FormLayoutCacheManager.getInstance().selectGridLayoutItemByPosition(itemInfo.page,
        itemInfo.row, itemInfo.column, isOuter);

    if (CheckEmptyUtils.isEmpty(cardInLayout)) {
      log.showWarn('cannot find cardInfo in layout by position');
      return;
    }
    FormLayoutCacheManager.getInstance().deleteGridLayoutItemByPosition(itemInfo.page, itemInfo.row, itemInfo.column,
      BusinessType.BUSINESS_CARD, true, isOuter);
    LaunchLayoutCacheManager.getInstance().deleteBlankPageFromLayoutInfo(itemInfo.page, isOuter);
  }

  /**
   * reset card info and notify refresh component
   *
   * @param cardId card id
   */
  resetCard(cardId: string): void {
    if (!cardId) {
      log.showWarn('resetCard id undefined');
      return;
    }
    log.showInfo('resetCard id %{public}s', cardId);
    GlobalContext.getContext()?.eventHub.emit(AiSuggestionEventName.getResetCardEventName(cardId), cardId);
  }

  /**
   * reset card info and notify refresh component
   *
   * @param cardId card id
   */
  resetCardInfo(cardId: string): void {
    if (!cardId) {
      log.showWarn('resetCardInfo id undefined');
      return;
    }
    log.showInfo('resetCardInfo id %{public}s', cardId);
    this.deleteForRemoveCard(cardId);
    this.cardInfoCacheMap.delete(cardId);
    RdbStoreManager.getInstance().deleteVoiceCardInfoByCardId(cardId);
  }

  private deleteForRemoveCard(cardId: string): void {
    // 获取当前这张母卡中所有的子卡id
    let idLists: Set<string> = new Set();
    let launcherCardInfo = this.cardInfoCacheMap.get(cardId);
    if (!launcherCardInfo) {
      log.showWarn(`deleteForRemoveCard cardId:${cardId}, launcherCardInfo invalid`);
      return;
    }
    launcherCardInfo.landscapeOrExpand?.recItems?.forEach((item) => {
      if (item.cardId) {
        idLists.add(item.cardId);
      }
    });
    launcherCardInfo.portrait?.recItems?.forEach((item) => {
      if (item.cardId) {
        idLists.add(item.cardId);
      }
    });
    log.showInfo(`deleteForRemoveCard cardId:${cardId}, child idLists:${Array.from(idLists).toString()}`);
    idLists.forEach(tmpCardId => {
      FormModel.getInstance().deleteFormByFormID(tmpCardId);
      this.cardIdCacheSet.delete(tmpCardId);
    });
    const oldIconIdList: string[] = (GlobalContext.getInstance().getObject('AiSuggestionSubItems') as string[]) ?? [];
    let iconIdList = oldIconIdList.filter((value) => {
      let iconIdInfo: string[] = value.split('_');
      let parentCardId: string = iconIdInfo[iconIdInfo.length - 1];
      return parentCardId !== cardId;
    });
    GlobalContext.getInstance().setObject('AiSuggestionSubItems', iconIdList);
  }

  /**
   * get all cache card info
   */
  public getAllCardInfoCache(): Map<string, LauncherCardInfo> {
    log.showInfo('getAllCardInfoCache:%{public}s', Array.from(this.cardInfoCacheMap.keys()));
    return this.cardInfoCacheMap;
  }

  /**
   * 获取所有的语音助手建议子卡ID
   *
   * @returns 子卡ID列表
   */
  public async getAllInnerCardId(): Promise<string[]> {
    let cardIdList = AiSuggestionRdbHelper.getAllInnerCardIdFromRdb();
    log.showDebug('getAllInnerCardId: %{public}s', cardIdList.toString());
    return cardIdList;
  }

  /**
   * 场景卡-设置卡片已经曝光过，语音助手建议读取这个值，下次推荐时，将needDelayShow改成0（表示不需要延迟展示）
   *
   * @param cardDimension 卡片尺寸
   * @param portfolioId 场景卡id
   */
  public setExposeStatus(cardDimension: number | undefined, portfolioId: string): void {
    let key: string = portfolioId + '_' + cardDimension + '_exposeStatus';
    log.showInfo('setExposeStatus, key:%{public}s', key);
    settingsDataManager.setValue(null, key, 'true');
  }

  /**
   * 克隆时会删除新机上重复的卡片，克隆后需要将删除卡片的资源清除
   */
  public clearDeletedCards(): void {
    const infoList: GridLayoutItemInfo[] = AbilityFormUtil.getAllAiSuggestionItems();
    const ids: string[] =
      infoList.map(item => item.cardId ?? '').filter(cardId => !CheckEmptyUtils.checkStrIsEmpty(cardId));
    const cachedIds: string[] = Array.from(this.cardInfoCacheMap.keys());
    log.showInfo(`clearDeletedCards clonedIds: ${ids.toString()} cachedIds: ${cachedIds.toString()}`);
    for (const cardId of cachedIds) {
      if (!ids.includes(cardId)) {
        log.showInfo(`clearDeletedCards cardId: ${cardId}`);
        this.deleteCardInfoAfterAnimation(cardId);
      }
    }
  }

  public updateSubCardId(cardId: string | undefined, recItem: LauncherRecItem, newCardId: string): void {
    if (!recItem || AbilityFormUtil.isCardIdInvalid(cardId ?? '')) {
      log.showWarn(`updateCardId voice:${cardId} params is invalid, newCardId: ${newCardId}`);
      return;
    }
    const cardInfo: LauncherCardInfo | undefined = this.getCardInfo(cardId);
    if (!cardInfo) {
      log.showWarn(`updateCardId voice:${cardId} cardInfo not exists, newCardId: ${newCardId}`);
      return;
    }

    const portraitRecItem: LauncherRecItem | undefined = this.findItem(cardInfo.portrait?.recItems ?? [], recItem);
    if (portraitRecItem) {
      log.showInfo(`updateCardId portrait cardId=${cardId}, recItem:${recItem.bundleName}, newCardId:${newCardId} success`);
      portraitRecItem.cardId = newCardId;
    }

    const landscapeOrExpandItem: LauncherRecItem | undefined =
      this.findItem(cardInfo.landscapeOrExpand?.recItems ?? [], recItem);
    if (landscapeOrExpandItem) {
      log.showInfo(`updateCardId landscapeOrExpandItem cardId=${cardId}, recItem:${recItem.bundleName}, newCardId:${newCardId} success`);
      landscapeOrExpandItem.cardId = newCardId;
    }
  }

  private findItem(recItems: LauncherRecItem[], recItem: LauncherRecItem): LauncherRecItem | undefined {
    return recItems?.find((oldItem: LauncherRecItem) => {
      return oldItem && oldItem.itemType === CommonConstants.TYPE_CARD && oldItem.itemType === recItem.itemType &&
        oldItem.bundleName === recItem.bundleName && oldItem.moduleName === recItem.moduleName &&
        oldItem.abilityName === recItem.abilityName && oldItem.formName === recItem.formName &&
        oldItem.dimension === recItem.dimension && oldItem.serviceId === recItem.serviceId;
    });
  }

  public setFormVisible(cardId: string | undefined, visible: boolean): void {
    if (cardId) {
      this.formVisible.set(cardId, visible);
    }
  }

  public isFormVisible(cardId: string): boolean {
    return this.formVisible.get(cardId) ?? true;
  }

  /**
   * 设置特性版本
   *
   * @param featureVersion
   */
  public setFeatureVersion(featureVersion: number): void {
    if (CheckEmptyUtils.isEmpty(featureVersion)) {
      return;
    }
    this.featureVersion = featureVersion;
  }

  /**
   * 获取特性版本
   *
   * @returns
   */
  public getFeatureVersion(): number {
    log.showInfo(`getFeatureVersion ${this.featureVersion}`);
    return this.featureVersion;
  }

  async setTouchSnapshotImage(srcImage: image.PixelMap, comId: string): Promise<void> {
    if (!srcImage || srcImage.getPixelBytesNumber() <= 0) {
      log.showError('src pixelMap invalid!');
      return;
    }
    try {
      // 释放旧截图资源
      await this.snapshotImage?.release();
      ResourceManager.getInstance().deleteAppResourceCache(this.snapComponentId, 'cardSnapshot');
      this.snapComponentId = comId;
      this.snapshotImage = srcImage;
      ResourceManager.getInstance().setAppResourceCache(comId, 'cardSnapshot', srcImage);
      CloseAppManager.getInstance().setCardStartSnapshot(comId, srcImage);
    } catch (error) {
      log.showError(`aiSuggestion pixelMap error: ${error?.code} ${error?.message}`);
    }
  }

  public cacheSnapshotImage(recItem: LauncherRecItem, index: number, eventType: TouchType,
    cardId: string | undefined, isVisible: () => boolean = (): boolean => { return true; }): void {
    if (eventType === TouchType.Down && isVisible?.()) {
      log.showInfo('onTouch down start');
      // 启动动效过程中，取缓存截图，避免消失问题
      try {
        log.showInfo('start app animation state, get card snap shot');
        let componentId: string = AiSuggestionDataHelper.getFormId(recItem);
        componentSnapshot.get(componentId)?.then((value: image.PixelMap) => {
          log.showInfo('start app animation state, get card snap shot completed');
          const comId: string = AiSuggestionDataHelper.getFormId(recItem);
          this.setTouchSnapshotImage(value, comId);
        }).catch((error: Error) => {
          log.error(`componentSnapshot error ${componentId} `, error);
        });
      } catch (error) {
        log.error('onTouch componentSnapshot error', error);
      }
    }
  }
}