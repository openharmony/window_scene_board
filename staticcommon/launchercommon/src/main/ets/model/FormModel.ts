/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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

import { image } from '@kit.ImageKit';
import { formInfo } from '@kit.FormKit';
import bundleManager from '@ohos.bundle.bundleManager';
import { promptAction } from '@kit.ArkUI';
import formHost from '@ohos.app.form.formHost';
import { systemParameter } from '@kit.BasicServicesKit';
// import cloudCapabilityManager from '@ohos.core.deviceCloudGateway.cloudCapabilityManager';
import {
  LogDomain,
  LogHelper,
  CheckEmptyUtils,
  PixelMapUtil,
} from '@ohos/basicutils';
import {
  localEventManager,
  LogCollectUtil,
  DeviceHelper,
  ResourceManager,
  IconResourceManager
} from '@ohos/frameworkwrapper';
import { launcherStatusUtil, SCBOobeManager } from '@ohos/windowscene';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { PinyinSort } from '@ohos/frameworkpinyin';
import { EventConstants } from '../constants/EventConstants';
import { BusinessType, CardCloneStatus, CommonConstants } from '../constants/CommonConstants';
import { CardItemInfo } from '../bean/CardItemInfo';
import { CardInfo, AppItemCardInfo } from '../bean/AppItemCardInfo';
import GridLayoutUtil from '../utils/GridLayoutUtil';
import { FormManager } from '../manager/FormManager';
import { RdbStoreManager } from '../db/RdbStoreManager';
import { FormListInfoCacheManager } from '../cache/FormListInfoCacheManager';
import { SwiperItemInfo } from '../entity/SwiperItemInfo';
import type GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { FormLayoutCacheManager } from '../cache/layout/FormLayoutCacheManager';
import {
  AppItemInfo,
  AppModel,
  AtomicServiceAppModel,
  DesktopLayoutState,
  FormCommonUtil,
  LaunchLayoutCacheManager,
  ReceiveEventInfo,
  SettingsModel,
  FormRelationManager,
} from '../TsIndex';
import { NoIconAppModel } from './NoIconAppModel';

const TAG = 'FormModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const KEY_FORM_LIST = 'formListInfo';
const SCREEN_LOCK_FORM_WHITE_LIST: string[] = ['com.ohos.totemweather',
  'com.ohos.clock', 'com.openharmony.it.works', 'com.ohos.calculator', 'com.ohos.audioaccessorymanager',
  'com.ohos.musicservice', 'com.openharmony.it.welink'];
const SCREEN_LOCK_AGC_PERMISSION_NAME: string = 'com.openharmony.service.screenlock.form';
const NEW_SCREEN_LOCK_FORM_WHITE_LIST: string[] = ['com.ohos.health', 'com.ohos.soundrecorder', 'com.sinocare.ican'];

export const enum FormModelValidCardType {
  /**
   * 负一屏
   */
  INTELLIGENT = 'Intelligent',

  /**
   * 语音助手建议
   */
  /**
   * 简易模式/小外屏等独立布局表
   */
  RDB_GRIDLAYOUT_TABLE_INDEPENDENT = 'RdbGridLayoutTableIndependent',

  /**
   * 锁屏
   */
  SCREEN_LOCK = 'ScreenLock',

  /**
   * qxs pc模式下卡片
   */
  QXS_PC_MODE_CARD = 'QxsPcModeCard',

  /**
   * 户外模式模式下的卡片
   */
  OUTDOOR_CARD = 'OutdoorCard'
}

/**
 * form model.
 */
export class FormModel {
  private readonly mRdbStoreManager: RdbStoreManager;
  private readonly mFormManager: FormManager;
  private readonly mFormListInfoCacheManager: FormListInfoCacheManager;
  private mFormLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
  private mNoIconAppModel: NoIconAppModel = NoIconAppModel.getInstance();
  private mAppItemFormInfoMap: Map<string, CardItemInfo[]> = new Map<string, CardItemInfo[]>();
  private mFormsAppList: AppItemInfo[] = [];
  private mAllCardItemInfo: CardItemInfo[] = [];
  private mFormManagerLastShowFrom?: number;
  private queryValidCardCallbackMap: Map<string, Function> = new Map();
  private formLengthInRdb: number = 0;
  private newScreenLockWhiteList: string[] = [...NEW_SCREEN_LOCK_FORM_WHITE_LIST];

  private constructor() {
    log.showInfo('constructor start');
    this.mRdbStoreManager = RdbStoreManager.getInstance();
    this.mFormManager = FormManager.getInstance();
    this.mFormListInfoCacheManager = FormListInfoCacheManager.getInstance();
    LogCollectUtil.getInstance().registerCollectLogCallback(TAG, (collectLogTag: string) => {
      const logCollect: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, collectLogTag);
      logCollect.showInfo(`current forms num = ${this.mAllCardItemInfo.length}`);
      for (let i = 0; i < this.mAllCardItemInfo.length; i++) {
        logCollect.showInfo(`form item${i} = bundleName: ${this.mAllCardItemInfo[i]?.bundleName}, ` +
        `cardName: ${this.mAllCardItemInfo[i]?.cardName}`);
      }
    });
  }

  /**
   * Get the form model object.
   *
   * @return {object} form model singleton
   */
  static getInstance(): FormModel {
    if (globalThis.FormModelInstance == null) {
      globalThis.FormModelInstance = new FormModel();
    }
    return globalThis.FormModelInstance;
  }

  /**
   * Register the form card change event listener.
   *
   * @param listener
   */
  registerJumpToFormViewEvent(listener: ReceiveEventInfo): void {
    localEventManager.registerEventListener(listener, [EventConstants.EVENT_REQUEST_JUMP_TO_FORM_VIEW]);
  }

  /**
   * Unregister event listener.
   *
   * @param listener
   */
  unregisterEventListener(listener: ReceiveEventInfo): void {
    localEventManager.unregisterEventListener(listener);
  }

  public checkIfCardExceedLimit(): boolean {
    let formLen: number = this.mFormLayoutManager.getAllFormsLen();
    let maxForm: number = FormLayoutCacheManager.getInstance().selectMaxForm();
    log.showWarn(`checkCardExceedLimit, formCount:${formLen}, maxLen:${maxForm}`);
    if (formLen >= maxForm) {
      log.showWarn(`formLen exceeds limit, formCount:${formLen}, maxLen:${maxForm}`);
      return true;
    }
    return false;
  }

  public setPixmapMemoryName(pixmap: image.PixelMap, name: string): void {
    if (CheckEmptyUtils.isEmpty(pixmap) || CheckEmptyUtils.checkStrIsEmpty(name)) {
      log.showError(`params invalid ${!pixmap} ${name}`);
      return;
    }
    PixelMapUtil.addName(pixmap, name);
  }

  public showToastWhenCardExceed(): void {
    promptAction.showToast({
      message: ResourceManager.getInstance().getStringByName('form_in_desktop_exceed'),
      showMode: 2
    });
  }

  // 注册各模块持久化的有效卡片查询回调函数
  public registerQueryValidCardIdCallback(cardType: string, callback: Function): void {
    log.showDebug('register valid cardId function callback, type:%{public}s', cardType);
    this.queryValidCardCallbackMap.set(cardType, callback);
  }

  public async clearInvalidCards(): Promise<void> {
    if (SCBOobeManager.isOobeActivated()) {
      log.showWarn('in oobe, not clear cards');
      AppStorage.setOrCreate('isClearInvalidCardsDone', true);
      return;
    }
    log.showWarn('clear invalid cards.');
    let formIds: string[] = [];

    for (let myEntry of this.queryValidCardCallbackMap) {
      let key = myEntry[0];
      let value = myEntry[1];
      let cardIdList: string[] | undefined;
      try {
        cardIdList = await value();
      } catch (err) {
        log.error(`query valid cards failed, type: ${key}, err:%{public}s`, err);
      }
      if (!cardIdList) {
        continue;
      }
      formIds.push(...cardIdList);
      log.showWarn('query valid cards, type:%{public}s, list:%{public}s', key, JSON.stringify(cardIdList));
    }

    let cardIdList = (await this.mRdbStoreManager.getAllFormInfosInHomeMode()).map(item => item.cardId);
    formIds.push(...cardIdList);

    log.showWarn('query valid cards, type:formManager, list:%{public}s', JSON.stringify(cardIdList));

    // 刷机场景下，最开始数据库接口可能获取不到可用卡片，此时清理会和卡片创建有时序问题
    if (formIds.length === 0 || formIds.every(item => CheckEmptyUtils.checkStrIsEmpty(item))) {
      AppStorage.setOrCreate('isClearInvalidCardsDone', true);
      return;
    }
    FormCommonUtil.reportClearInvalidCardsId(formIds);
    try {
      // 卡片框架清理接口
      formHost.deleteInvalidForms(formIds).then(() => {
        log.showWarn('clear invalid cards done, valid cards count:%{public}d', formIds.length);
        AppStorage.setOrCreate('isClearInvalidCardsDone', true);
      });
    } catch (err) {
      log.showError('doClearInvalidCards err:%{public}s', err);
      AppStorage.setOrCreate('isClearInvalidCardsDone', true);
    }
  }

  /**
   * Get the form info list of all ohos applications on the device.
   *
   * @return {array} allFormList
   */
  async getAllFormsInfo(): Promise<CardItemInfo[]> {
    log.showWarn('getAllFormsInfo start');
    const allFormList: CardItemInfo[] = await this.mFormManager.getAllFormsInfo();
    return allFormList;
  }

  private async getAppItemCards(defaultDisplayName: string, appItemFormInfos: CardItemInfo[]): Promise<CardInfo[]> {
    let cards: CardInfo[] = [];
    for (let item of appItemFormInfos) {
      let displayName: string = await IconResourceManager.getInstance().getAppName(item.displayNameId, item.bundleName,
        item.moduleName, '');
      cards.push({
        moduleName: item.moduleName,
        abilityName: item.abilityName,
        displayName: displayName || defaultDisplayName,
        cardName: item.cardName
      })
    }
    return cards;
  }

  private async convertToAppItemCardInfo(appItem: AppItemInfo | undefined, bundleName: string,
    appItemFormInfos: CardItemInfo[]): Promise<AppItemCardInfo | undefined> {
    let appItemCardInfo: AppItemCardInfo = new AppItemCardInfo();
    appItem = appItem || this.getAppInfoByBundleName(bundleName);
    if (!appItem) {
      log.showWarn('invalid appItem');
      return undefined;
    }
    let status: number = launcherStatusUtil.getSimpleModeStatus() ?
      DesktopLayoutState.SIMPLE_LAUNCHER_MODEL : DesktopLayoutState.HOME_LAUNCHER_MODE;
    // 无图标应用
    if (this.mNoIconAppModel.checkNoIconAppItem(bundleName)) {
      log.showWarn(`no icon app bundleName: ${appItem.bundleName}, applicationName: ${appItem.applicationName}`);
      appItemCardInfo.appName = appItem.applicationName ?? '';
    } else {
      if (!appItem.appLabelId) {
        log.showWarn('invalid appLabelId');
        return undefined;
      }
      // 获取应用名称
      let appName: string = await IconResourceManager.getInstance().getAppName(appItem.appLabelId, appItem.bundleName,
        appItem.moduleName, '');
      appItemCardInfo.appName = appName;
    }
    appItemCardInfo.bundleName = appItem.bundleName;
    appItemCardInfo.appIndex = appItem.appIndex || 0;
    appItemCardInfo.cards = await this.getAppItemCards(appItemCardInfo.appName, appItemFormInfos);
    appItemCardInfo.status = status;
    return appItemCardInfo;
  }

  public async batchInsertAppItemFormInfo(appList: AppItemInfo[]): Promise<boolean> {
    let appItemCardInfoList: AppItemCardInfo[] = [];
    for (let appItem of appList) {
      if (!appItem || !appItem.bundleName) {
        continue;
      }
      let appItemFormInfos: CardItemInfo[] = await this.getFormsInfoFromMapAndManager(appItem.bundleName);
      let filterFormInfos: CardItemInfo[] = appItemFormInfos.filter(formInfo => this.isFormCenterSupportCard(formInfo));
      if (!filterFormInfos.length) {
        continue;
      }
      let appItemCardInfo: AppItemCardInfo | undefined =
        await this.convertToAppItemCardInfo(appItem, appItem.bundleName, filterFormInfos);
      if (!appItemCardInfo) {
        continue;
      }
      appItemCardInfoList.push(appItemCardInfo);
    }
    if (!appItemCardInfoList.length) {
      log.showWarn('no appItemCardInfo insert');
      return false;
    }
    return await this.mRdbStoreManager.batchInsertAppItemFormInfo(appItemCardInfoList);
  }

  public async deleteAppItemFormInfoInDB(bundleName: string): Promise<boolean> {
    log.showInfo('deleteAppItemFormInfoInDB');
    return await this.mRdbStoreManager.deleteAppItemFormInfo(bundleName);
  }

  convertToFormItem(sourceInfo: GridLayoutItemInfo): CardItemInfo {
    let formInfoTmp: CardItemInfo = new CardItemInfo();
    formInfoTmp.cardId = sourceInfo.cardId ?? '';
    formInfoTmp.bundleName = sourceInfo.bundleName;
    formInfoTmp.abilityName = sourceInfo.abilityName;
    formInfoTmp.moduleName = sourceInfo.moduleName ?? '';
    formInfoTmp.cardName = sourceInfo.cardName ?? '';
    formInfoTmp.isTransparent = sourceInfo.isTransparent ?? false;
    formInfoTmp.formConfigAbility = sourceInfo.formConfigAbility;
    formInfoTmp.appLabelId = sourceInfo.appLabelId;
    formInfoTmp.area = sourceInfo.area;
    formInfoTmp.page = sourceInfo.page;
    formInfoTmp.column = sourceInfo.column;
    formInfoTmp.row = sourceInfo.row;
    formInfoTmp.extend1 = sourceInfo.extend1;
    formInfoTmp.extend2 = sourceInfo.extend2;
    formInfoTmp.cardDimension = CardItemInfo.getCardDimension(sourceInfo.area ?? []);
    formInfoTmp.intent = sourceInfo.intent;
    formInfoTmp.gameCardInfo = sourceInfo.gameCardInfo;
    formInfoTmp.isFormDimension1x4 = sourceInfo.isFormDimension1x4 ?? false;
    return formInfoTmp;
  }

  public getAllFormsInfoFromLayout(isOuter?: boolean): GridLayoutItemInfo[] {
    log.showWarn('get all forms from layout');
    return this.mFormLayoutManager.selectAllFormsList(isOuter);
  }

  public getDesktopAllFormsBundle(): Set<string> {
    let bundleSet: Set<string> = new Set<string>();
    this.getAllFormsInfoFromLayout().forEach((item) => {
      bundleSet.add(item.bundleName);
    });
    return bundleSet;
  }

  /**
   * Get the form info list of all ohos applications on the device by bundle name.
   *
   * @param {array} bundleName
   * @param {function | undefined} callback
   * @return {array} currentBundleFormsInfo
   */
  async getFormsInfoByBundleName(bundleName: string, callback?: Function): Promise<CardItemInfo[]> {
    let currentBundleFormsInfo: CardItemInfo[] = [];
    await this.mFormManager.getFormsInfoByApp(bundleName)
      .then(bundleFormsInfo => {
        log.showDebug(`getFormsInfoByBundleName bundleFormsInfo: ${bundleName}`);
        currentBundleFormsInfo = bundleFormsInfo;
        if (callback !== undefined) {
          callback(bundleName, bundleFormsInfo);
        }
      })
      .catch((err: Error) => {
        log.showDebug(`getFormsInfoByBundleName err: ${err?.message}`);
      });
    return currentBundleFormsInfo;
  }

  getRealForm(cardItemInfos: CardItemInfo[]): CardItemInfo[] | null {
    if (cardItemInfos.length <= 0) {
      return null;
    }
    let result: CardItemInfo[] = [];
    for (let j: number = 0; j < cardItemInfos.length; j++) {
      let dimensions: number[] = cardItemInfos[j].supportDimensions;
      for (let i: number = 0; i < dimensions.length; i++) {
        const tempCard = new CardItemInfo();
        this.copyCardItemInfo(tempCard, cardItemInfos[j]);
        let tempDimensions: number[] = [];
        tempDimensions.push(dimensions[i]);
        tempCard.supportDimensions = tempDimensions;
        tempCard.cardDimension = dimensions[i];
        tempCard.area = this.mFormManager.getCardSize(tempCard.cardDimension);
        result.push(tempCard);
      }
    }
    return result;
  }

  private copyCardItemInfo(newCard: CardItemInfo, oldCard: CardItemInfo): void {
    newCard.descriptionId = oldCard.descriptionId;
    newCard.displayNameId = oldCard.displayNameId;
    newCard.bundleName = oldCard.bundleName;
    newCard.abilityName = oldCard.abilityName;
    newCard.moduleName = oldCard.moduleName;
    newCard.cardName = oldCard.cardName;
    newCard.formConfigAbility = oldCard.formConfigAbility;
    newCard.isTransparent = oldCard.isTransparent;
  }

  /**
   * Get the full form info list of all ohos applications on the device by bundle name.
   *
   * @param {array} bundleName
   * @param {function | undefined} callback
   * @return {array} currentBundleFormsInfo
   */
  async getFullFormsInfoByBundleName(bundleName: string, callback?: Function): Promise<CardItemInfo[] | null> {
    let currentBundleFormsInfo: CardItemInfo[] | null;
    currentBundleFormsInfo = await this.getFormsInfoByBundleName(bundleName, callback);
    currentBundleFormsInfo = this.getRealForm(currentBundleFormsInfo);
    AppStorage.setOrCreate('formMgrItem', currentBundleFormsInfo);
    return currentBundleFormsInfo;
  }

  /**
   * Get the form info list from rdb.
   *
   * @return {array} allFormList
   */
  async getAllFormsInfoFromRdb(): Promise<CardItemInfo[]> {
    log.showWarn('getAllFormsInfoFromRdb start');
    this.mAllCardItemInfo = await this.mRdbStoreManager.getAllFormInfos();
    this.formLengthInRdb = this.mAllCardItemInfo.length;
    return this.mAllCardItemInfo;
  }

  public getAllFormLengthFormRdb(): number {
    return this.formLengthInRdb;
  }


  /**
   * Get the form info list except stack from rdb.
   *
   * @return {array} allFormList
   */
  async getAllFormsInfoExceptStackFromRdb(isOuter?: boolean): Promise<CardItemInfo[]> {
    log.showWarn('getAllFormsInfoExceptStackFromRdb start');
    this.mAllCardItemInfo = await this.mRdbStoreManager.getAllFormExceptStackInfos(isOuter);
    return this.mAllCardItemInfo;
  }

  /**
   * Update the form info in rdb by id.
   *
   * @param {object} cardItemInfo
   * @return {boolean} result
   */
  async updateFormInfoById(cardItemInfo: CardItemInfo): Promise<boolean> {
    return await this.mRdbStoreManager.updateFormInfoById(cardItemInfo);
  }

  /**
   * Update the form configAbility info in rdb by id.
   *
   * @param {object} cardItemInfo
   * @return {boolean} result
   */
  async updateFormConfigInfo(cardItemInfo: CardItemInfo): Promise<boolean> {
    return await this.mRdbStoreManager.updateFormConfigInfo(cardItemInfo);
  }

  /**
   * Update the form info in rdb by position.
   *
   * @param {object} cardItemInfo
   * @return {boolean} result
   */
  async updateFormInfoByPosition(cardItemInfo: CardItemInfo): Promise<boolean> {
    return await this.mRdbStoreManager.updateFormInfoByPosition(cardItemInfo);
  }

  /**
   * Delete form in rdb and fms by id.
   *
   * @param {string} cardId
   */
  deleteFormById(cardId: string, isOnlyDeleteLocal: boolean, isOuter: boolean,
    removeDelay: number, isNeedDelFrameForm = true): void {
    this.mRdbStoreManager.deleteFormInfoById(cardId, isOuter);
    this.formLengthInRdb--;
    if (isOnlyDeleteLocal) {
      return;
    }
    if (removeDelay) {
      setTimeout(() => {
        this.mFormManager.deleteCard(cardId, isNeedDelFrameForm);
      }, removeDelay);
      return;
    }
    this.mFormManager.deleteCard(cardId, isNeedDelFrameForm);
  }

  /**
   * Delete form in rdb and fms by id.
   *
   * @param {string} cardId
   */
  async deleteFormByIdAsync(cardId: string, isOnlyDeleteLocal: boolean, isNeedDelFrameForm = true): Promise<void> {
    await this.mRdbStoreManager.deleteFormInfoById(cardId);
    if (isOnlyDeleteLocal) {
      return;
    }
    await this.mFormManager.deleteCard(cardId, isNeedDelFrameForm);
  }

  /**
   * Delete form in fms by formId.
   *
   * @param {string} formId
   */
  deleteFormByFormID(formId: string, isOnlyDeleteLocal?: boolean): void {
    if (isOnlyDeleteLocal) {
      log.showWarn(`deleteFormByFormID DeskTop drag card to Intelligent`);
      return;
    }
    this.mFormManager.deleteCard(formId);
  }

  deleteFormByFormIdStr(formId?: string): void {
    this.mFormManager.deleteCard(formId ?? '');
  }

  /**
   * Converts a specified temporary form that has been obtained by the application into a normal form.
   *
   * @param {string} formId
   */
  convertsNormalFrom(formId: string): void {
    this.mFormManager.castTempForm(formId);
  }

  /**
   * Set app item form info into map.
   *
   * @param {string} bundleName
   * @param {array} appItemFormInfo
   */
  private setAppItemFormInfo(bundleName: string, appItemFormInfo: CardItemInfo[]): void {
    if (!CheckEmptyUtils.isEmptyArr(appItemFormInfo)) {
      this.mAppItemFormInfoMap.set(bundleName, appItemFormInfo);
    }
  }

  private sortServiceFormAppList(serviceFormAppList: AppItemInfo[]): void {
    if (serviceFormAppList.length <= 1) {
      return;
    }
    let pinyinSort: PinyinSort = new PinyinSort();
    log.showWarn(`start sort list length ${serviceFormAppList.length}`);
    serviceFormAppList.sort((item1, item2) => {
      return pinyinSort.sortByParameter(String(item1.applicationName), String(item2.applicationName));
    });
  }

  public getAppInfoByBundleName(bundleName: string): AppItemInfo | undefined {
    let appItem: AppItemInfo | undefined = AppModel.getInstance().getAppInfoByBundleName(bundleName);
    if (appItem) {
      return appItem;
    }
    return AtomicServiceAppModel.getInstance().getAtomicInfoByBundleName(bundleName);
  }

  public async updateFormsAppInfo(): Promise<void> {
    let newAppList: AppItemInfo[] = [];
    this.mNoIconAppModel.clearCache();
    for (let bundleName of this.mAppItemFormInfoMap.keys()) {
      let appInfo: AppItemInfo | undefined = this.getAppInfoByBundleName(bundleName);
      if (!appInfo) {
        log.showWarn(`${bundleName} get appInfo failed`);
        continue;
      }
      await this.fillAppInfo(appInfo);
      newAppList.push(appInfo);
    }
    this.mNoIconAppModel.getNoIconAppItemInfo().forEach((appInfo) => {
      if (!newAppList.some(item => item.bundleName === appInfo.bundleName)) {
        newAppList.push(appInfo);
      }
    });
    this.mFormsAppList = newAppList;
    this.mFormsAppList.forEach((appItem: AppItemInfo) => {
      this.updateScreenLockWhiteList(appItem.bundleName);
    });
    this.sortServiceFormAppList(newAppList);
    this.updateAllAppItemFormInfoInDB(newAppList);
  }

  private async fillAppInfo(appInfo: AppItemInfo): Promise<void> {
     appInfo.applicationName = await IconResourceManager.getInstance().getAppName(appInfo.appLabelId,
       appInfo.bundleName, appInfo.moduleName, '');
  }

  private async updateAllAppItemFormInfoInDB(appList: AppItemInfo[]): Promise<void> {
    let finalAppList: AppItemInfo[] = [...appList];
    // 全量删除card_info表中的应用卡片数据
    let result: boolean = await this.mRdbStoreManager.deleteAllAppItemFormInfo();
    if (!result) {
      log.showWarn('deleteAllAppItemFormInfo failed');
      return;
    }
    // 检查列表中是否存在元服务应用
    let atomicServiceIndex: number = finalAppList.findIndex((appItem: AppItemInfo) => {
      return appItem.bundleName.startsWith('com.atomicservice');
    })
    // 获取元服务应用列表
    if (atomicServiceIndex < 0) {
      if (SCBOobeManager.isEnable()) {
        log.showWarn('in oobe, do not query AtomicServiceAppList');
      } else {
        let atomicServiceAppList: AppItemInfo[] = await AtomicServiceAppModel.getInstance().getAtomicServiceAppList();
        finalAppList.push(...atomicServiceAppList);
      }
    }
    // 批量插入新的应用卡片数据
    this.batchInsertAppItemFormInfo(finalAppList);
  }

  async updateAppFormsInfo(launcherAbilityList?: AppItemInfo[]): Promise<void> {
    let totalFormsMap: Map<string, CardItemInfo[]> = new Map<string, CardItemInfo[]>();
    this.mNoIconAppModel.clearCache();
    let formsList: CardItemInfo[] = await this.mFormManager.getAllFormsInfo();
    formsList.forEach(item => {
      let formList: CardItemInfo[] = [];
      if (totalFormsMap.has(item.bundleName)) {
        formList = totalFormsMap.get(item.bundleName) as CardItemInfo[];
      }
      formList.push(item);
      totalFormsMap.set(item.bundleName, formList);
    });
    this.batchLog(10, totalFormsMap, launcherAbilityList);
    this.mAppItemFormInfoMap = totalFormsMap;
    await this.updateFormsAppInfo();
    log.showWarn(`current appFormMap size: ${this.mAppItemFormInfoMap.size} appList size: ${this.mFormsAppList.length}`);
  }

  private batchLog(batchSize: number, totalFormsMap: Map<string, CardItemInfo[]>, abilityList?: AppItemInfo[]): void {
    let bundleNames: string[] = [];
    abilityList?.forEach((item) => {
      if (!totalFormsMap.has(item.bundleName)) {
        bundleNames.push(item.bundleName);
        if (bundleNames.length === batchSize) {
          log.showWarn(`app ${bundleNames} no forms`);
          bundleNames = [];
        }
      }
    });

    if (bundleNames.length > 0) {
      log.showWarn(`app ${bundleNames} no forms`);
    }
  }

  private getNoIconAppListWhenHasForm(filter?: (item: CardItemInfo) => boolean): AppItemInfo[] {
    let noIconAppList: AppItemInfo[] = this.mNoIconAppModel.getNoIconAppItemInfo();
    if (CheckEmptyUtils.isEmptyArr(noIconAppList)) {
      return [];
    }
    let NoIconListHasForm: AppItemInfo[] = noIconAppList.filter(item => this.checkNoIconSupportForm(item.bundleName, filter));
    return NoIconListHasForm;
  }

  private checkNoIconSupportForm(bundleName: string, filter?: (item: CardItemInfo) => boolean): boolean {
    if (!this.mAppItemFormInfoMap.has(bundleName)) {
      return false;
    }
    return this.mAppItemFormInfoMap.get(bundleName)?.some(item => !filter || filter?.(item)) ?? false;
  }

  public async getFormCenterAppList(filter?: (item: CardItemInfo) => boolean): Promise<AppItemInfo[]> {
    let formCenterAppList: AppItemInfo[] = [];
    log.showInfo(`mFormsAppList: ${this.mFormsAppList.length}`);
    this.mFormsAppList.forEach((appInfo: AppItemInfo) => {
      if (!filter) {
        return;
      }
      if (this.mAppItemFormInfoMap.get(appInfo.bundleName)?.filter(filter).length) {
        formCenterAppList.push(appInfo);
        log.showWarn(`formCenterAppList push app: ${appInfo.bundleName} ${appInfo.applicationName}`);
      }
    });
    log.showWarn(`get formCenterAppList length: ${formCenterAppList.length}`);
    return formCenterAppList;
  }

  /**
   * Get app item form info from map.
   *
   * @param {string} bundleName
   * @return {array | undefined} mAppItemFormInfoMap
   */
  getAppItemFormInfo(bundleName: string, filter?: (item: CardItemInfo) => boolean): CardItemInfo[] | undefined {
    log.showDebug(`getAppItemFormInfo bundleName: ${bundleName}, ` +
      `appItemFormInfo: ${this.mAppItemFormInfoMap.get(bundleName)?.length}`);
    if (!filter) {
      return this.mAppItemFormInfoMap.get(bundleName);
    }
    return this.mAppItemFormInfoMap.get(bundleName)?.filter(filter);
  }


  private getNewForm(item: CardItemInfo, cardDimension: number): CardItemInfo {
    let formItem: CardItemInfo = new CardItemInfo();
    ObjectCopyUtil.deepClone(item, formItem);
    formItem.cardDimension = cardDimension;
    formItem.area = FormManager.getInstance().getCardSize(cardDimension);
    return formItem;
  }

  public getDesktopAppAndAtomicAndNoIconAppBundle(): Set<string> {
    let allDesktopAppBundleList: Set<string> = AppModel.getInstance().getDesktopAppBundle();
    AtomicServiceAppModel.getInstance().getDesktopAtomicBundle().forEach(item => allDesktopAppBundleList.add(item));
    this.mNoIconAppModel.getNoIconAppItemBundleList().forEach(item => allDesktopAppBundleList.add(item));
    return allDesktopAppBundleList;
  }

  /**
   * Get app item total form info from map with filter.
   *
   * @param {string} bundleName
   * @return {array | undefined} mAppItemFormInfoMap
   */
  public getAppItemTotalFormInfo(bundleName: string, filter?: (item: CardItemInfo) => boolean): CardItemInfo[] | undefined {
    let formList: CardItemInfo[] | undefined = this.mAppItemFormInfoMap.get(bundleName);
    let realList: CardItemInfo[] = [];
    log.showDebug(`getAppItemFormInfo bundleName: ${bundleName}, ` +
      `appItemFormInfo: ${this.mAppItemFormInfoMap.get(bundleName)?.length}`);
    formList?.forEach(item => {
      item.supportDimensions.forEach(cardDimension => {
        let formInfo: CardItemInfo = this.getNewForm(item, cardDimension);
        realList.push(formInfo);
      });
    });
    if (filter) {
      return realList.filter(filter);
    } else {
      return realList;
    }
  }

  /**
   * Get all app item form info map.
   *
   * @return {Map<string, CardItemInfo[]>} mAppItemFormInfoMap
   */
  getAllAppItemFormInfoMap(): Map<string, CardItemInfo[]> {
    return this.mAppItemFormInfoMap;
  }

  /**
   * Get app item form info from map, if not in map, try to find in manager.
   *
   * @param {string} bundleName
   * @return {Promise<CardItemInfo[]>}
   * @example
  * getFormsInfoFromMapAndManager.then((res) => {...});
   */
  async getFormsInfoFromMapAndManager(bundleName: string): Promise<CardItemInfo[]> {
    let cardInfo: CardItemInfo[] | undefined = this.mAppItemFormInfoMap.get(bundleName);
    if (typeof cardInfo === 'undefined') {
      return this.mFormManager.getFormsInfoByApp(bundleName)
        .then(bundleFormsInfo => {
          log.showDebug('getFormsInfoFromMapAndManager bundleFormsInfo: %{public}d', bundleFormsInfo?.length);
          return bundleFormsInfo;
        })
        .catch((err: Error) => {
          log.showDebug('getFormsInfoFromMapAndManager %{public}s err: %{public}s', bundleName, err?.message);
          return [];
        });
    }
    return cardInfo;
  }

  private async updateFormsAppList(bundleName: string, isNeedSort: boolean = true): Promise<void> {
    let appInfo: AppItemInfo | undefined;
    if (this.mNoIconAppModel.checkNoIconAppItem(bundleName)) {
      appInfo = this.mNoIconAppModel.getNoIconAppItemByBundle(bundleName);
    } else {
      appInfo = this.getAppInfoByBundleName(bundleName);
      if (appInfo) {
        await this.fillAppInfo(appInfo);
      }
    }
    if (!appInfo) {
      log.showError(`get ${bundleName} appInfo failed`);
      return;
    }

    let appIndex: number = this.mFormsAppList.findIndex(appInfo => appInfo.bundleName === bundleName);
    if (appIndex !== -1) {
      this.mFormsAppList[appIndex] = appInfo;
    } else {
      this.mFormsAppList.push(appInfo);
      if (isNeedSort) {
        this.sortServiceFormAppList(this.mFormsAppList);
      }
    }
  }

  /**
   * Update app item form info into map.
   *
   * @param {string} bundleName
   * @param {string | undefined} eventType
   */
  async updateAppItemFormInfo(bundleName: string, eventType?: string, isNeedSort: boolean = true): Promise<void> {
    this.mAppItemFormInfoMap.delete(bundleName);
    if (eventType && eventType === EventConstants.EVENT_PACKAGE_REMOVED) {
      this.removeBundleFromAppList(bundleName);
      this.removeScreenLockPermission(bundleName);
      return;
    }
    await this.getFormsInfoByBundleName(bundleName, this.setAppItemFormInfo.bind(this));
    if (!this.mAppItemFormInfoMap.has(bundleName)) {
      this.removeBundleFromAppList(bundleName);
      this.removeScreenLockPermission(bundleName);
      return;
    }
    await this.updateFormsAppList(bundleName, isNeedSort);
    this.updateScreenLockWhiteList(bundleName);
  }

  public async updateSingleAppItemFormInfo(bundleName: string): Promise<void> {
    log.showInfo('updateSingleAppItemFormInfo');
    await this.getFormsInfoByBundleName(bundleName, this.updateSingleAppItemFormInfoInDB.bind(this));
  }

  public async updateSingleAppItemFormInfoInDB(bundleName: string, appItemFormInfos: CardItemInfo[]): Promise<void> {
    log.showInfo('updateSingleAppItemFormInfoInDB');
    let filterFormInfos: CardItemInfo[] = appItemFormInfos.filter(formInfo => this.isFormCenterSupportCard(formInfo));
    if (!filterFormInfos.length) {
      log.showWarn(`${bundleName}, no cards after filter form center card`);
      return;
    }
    let appItemCardInfo: AppItemCardInfo | undefined =
      await this.convertToAppItemCardInfo(undefined, bundleName, filterFormInfos);
    if (!appItemCardInfo) {
      log.showWarn(`${bundleName}, invalid appItem`);
      return;
    }
    this.mRdbStoreManager.updateAppItemFormInfo(bundleName, appItemCardInfo);
  }

  /**
   * 删除卡片信息
   *
   * @param bundleName 包名
   */
  deleteAppItemFormInfo(bundleName: string): void {
    this.mAppItemFormInfoMap.delete(bundleName);
    this.removeScreenLockPermission(bundleName);
  }

  private getPageItemCountMap(): Map<string, number> {
    let pageItemCountMap: Map<string, number> = new Map();
    const allLayoutInfo: GridLayoutItemInfo[] = this.mFormLayoutManager.getAllGridLayoutItemList(
      BusinessType.BUSINESS_CARD, false);
    for (const item of allLayoutInfo) {
      if (CheckEmptyUtils.isEmpty(item.page)) {
        continue;
      }
      const tmpPage: string = item.page?.toString() ?? '';
      if (pageItemCountMap.has(tmpPage)) {
        pageItemCountMap.set(tmpPage, (pageItemCountMap.get(tmpPage) ?? 0) + 1);
      } else {
        pageItemCountMap.set(tmpPage, 1);
      }
    };
    return pageItemCountMap;
  }

  private updatePageItemCountMap(pageItemCountMap: Map<string, number>): void {
    const newPageItemCountMap: Map<string, number> = this.getPageItemCountMap();
    pageItemCountMap.forEach((value, key) => {
      if (!newPageItemCountMap.has(key)) {
        pageItemCountMap.set(key, 0);
      } else {
        pageItemCountMap.set(key, newPageItemCountMap.get(key) ?? 0);
      }
    });
  }

  /**
   * Delete form by bundleName and update layout info.
   *
   * @param {string} bundleName
   */
  async deleteFormByBundleName(bundleName: string, isOuter: boolean): Promise<void> {
    let pageItemCountMap: Map<string, number> = this.getPageItemCountMap();
    this.mFormLayoutManager.deleteGridLayoutItemByBundleNameAndType(bundleName, CommonConstants.TYPE_CARD,
      BusinessType.BUSINESS_CARD, true, isOuter);
    this.updatePageItemCountMap(pageItemCountMap);
    this.updateBlankPage(pageItemCountMap, isOuter);
    let formInfoList: CardItemInfo[] | undefined =
      this.mFormListInfoCacheManager.getCache(KEY_FORM_LIST) as CardItemInfo[];
    if (!formInfoList || CheckEmptyUtils.isEmptyArr(formInfoList)) {
      log.showInfo('current cache is null');
      return;
    }
    let formInfoListAfterDelete: CardItemInfo[] = formInfoList.filter(item => item.bundleName !== bundleName);
    if (formInfoListAfterDelete.length === 0) {
      this.mFormListInfoCacheManager.setCache(KEY_FORM_LIST, []);
    } else {
      this.mFormListInfoCacheManager.setCache(KEY_FORM_LIST, formInfoListAfterDelete);
    }
  }

  private updateBlankPage(pageItemCountMap: Map<string, number>, isOuter?: boolean): void {
    log.showInfo('updateBlankPage');
    let launcherLayout: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
    let pageCount: number = launcherLayout.selectPageCount(isOuter);
    log.showInfo(`updateBlankPage start, pageCount:${pageCount}`);
    const blankPages: number[] = [];
    for (let mEntry of pageItemCountMap) {
      let page = mEntry[0];
      let count = mEntry[1];
      log.showInfo(`pageIndex: ${page}, itemCount:${count}`);
      if (count === 0 && pageCount > 1) {
        pageCount--;
        blankPages.push(Number(page));
      }
    }
    launcherLayout.updatePageCount(pageCount, BusinessType.BUSINESS_BASIC_DESKTOP, true, isOuter);
    launcherLayout.updateLayoutAfterDeletePages(blankPages, BusinessType.BUSINESS_BASIC_DESKTOP, true);
  }

  private handleEventAfterFormDeleteInLayout(cardId: string, page: number, isOnlyDeleteLocal?: boolean, isOuter?: boolean): void {
    if (cardId) {
      // 布局接口整改后，不需要各业务触发数据库删除，但是需要通知框架删除对应的卡片id
      this.deleteFormByFormID(cardId, isOnlyDeleteLocal);
      this.deleteFormFromCache(cardId);
    }
    LaunchLayoutCacheManager.getInstance().deleteBlankPageFromLayoutInfo(page, isOuter);
  }

  public async deleteForm(cardId: string, isOnlyDeleteLocal?: boolean, isOuter?: boolean): Promise<void> {
    log.showWarn(`deleteForm start,cardId is: ${cardId}`);
    let cardInfo: GridLayoutItemInfo | undefined =
      this.mFormLayoutManager.selectGridLayoutItemByCardId(cardId, isOuter);
    if (!cardInfo) {
      log.showWarn('cannot find cardInfo in layout by cardId');
      return;
    }
    this.mFormLayoutManager.deleteGridLayoutItemByItemId(cardId, BusinessType.BUSINESS_CARD, true, isOuter);
    this.handleEventAfterFormDeleteInLayout(cardId, cardInfo.page ?? -1, isOnlyDeleteLocal, isOuter);
  }

  /**
   * Delete form from Cache.
   *
   * @param {cardId} cardId.
   */
  private deleteFormFromCache(cardId: string): void {
    const formInfoList: CardItemInfo[] = this.mFormListInfoCacheManager.getCache(KEY_FORM_LIST) as CardItemInfo[];
    if (!formInfoList || !Array.isArray(formInfoList)) {
      return;
    }
    for (let i = 0; i < formInfoList.length; i++) {
      if (formInfoList[i].cardId === cardId) {
        formInfoList.splice(i, 1);
        break;
      }
    }
    if (formInfoList.length === 0) {
      this.mFormListInfoCacheManager.setCache(KEY_FORM_LIST, []);
    } else {
      this.mFormListInfoCacheManager.setCache(KEY_FORM_LIST, formInfoList);
    }
  }

  /**
   * Delete form by CardInfo.
   *
   * @param {CardItemInfo} cardInfo.
   * @param {isOuter} outer screen flag
   */
  public deleteFormByPosition(cardInfo: CardItemInfo, isOuter?: boolean): boolean {
    if (CheckEmptyUtils.isEmpty(cardInfo)) {
      log.showError('deleteFormByPosition invalid parameter');
      return false;
    }
    log.showWarn(`deleteFormByPosition, page: ${cardInfo.page}, row: ${cardInfo.row}, column: ${cardInfo.column}` +
      `, isOuter: ${isOuter}`);
    let cardInLayout: GridLayoutItemInfo | undefined = this.mFormLayoutManager.selectGridLayoutItemByPosition(
      cardInfo.page ?? -1, cardInfo.row ?? 0, cardInfo.column ?? 0, isOuter);

    if (CheckEmptyUtils.isEmpty(cardInLayout)) {
      log.showWarn('cannot find cardInfo in layout by position');
      return false;
    }

    this.mFormLayoutManager.deleteGridLayoutItemByPosition(cardInfo.page ?? -1, cardInfo.row ?? 0, cardInfo.column ?? 0,
      BusinessType.BUSINESS_CARD, true, isOuter);
    this.handleEventAfterFormDeleteInLayout(cardInfo.cardId, cardInfo.page ?? -1, false, isOuter);
    return true;
  }

  public deleteFormCacheByCardItem(cardInfo: CardItemInfo, isOuter?: boolean): void {
    if (CheckEmptyUtils.isEmpty(cardInfo)) {
      log.showError('deleteFormCacheByCardItem invalid parameter');
      return;
    }
    if (CheckEmptyUtils.checkStrIsEmpty(cardInfo.cardId)) {
      this.deleteFormByPosition(cardInfo, isOuter);
    } else {
      this.deleteForm(cardInfo.cardId, false, isOuter);
    }
  }

  updateFormSizeAndPosition(cardItem: CardItemInfo): void {
    log.showWarn('updateFormSizeAndPosition start');
    this.mFormLayoutManager.updateFormSizeAndPosition(cardItem, BusinessType.BUSINESS_CARD);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
  }

  /**
   * Update the swiper form info in rdb
   *
   * @param {SwiperItemInfo} formItem - the swiper form info
   * @return {boolean} result
   */
  async updateSwiperFormInfo(formItem: SwiperItemInfo | CardItemInfo): Promise<boolean> {
    if (formItem instanceof CardItemInfo) {
      const itemInfo: SwiperItemInfo = new SwiperItemInfo();
      itemInfo.id = formItem.cardId;
      itemInfo.infoName = formItem.cardName;
      itemInfo.bundleName = formItem.bundleName;
      itemInfo.moduleName = formItem.moduleName;
      itemInfo.abilityName = formItem.abilityName;
      itemInfo.dimension = formItem.cardDimension;
      return await this.mRdbStoreManager.updateSwiperFormInfo(itemInfo);
    } else {
      return await this.mRdbStoreManager.updateSwiperFormInfo(formItem);
    }
  }

  async doBeforeJumpToFormManager(formBundleName : string): Promise<void> {
    const formItem = this.getAppItemTotalFormInfo(formBundleName,
      (item: CardItemInfo) => this.isFormCenterSupportCard(item));
    AppStorage.setOrCreate('formItem', formItem);
  }

  public setFormManagerLastShowFrom(showFrom: number): void {
    this.mFormManagerLastShowFrom = showFrom;
  }

  public getFormManagerLastShowFrom(): number | undefined {
    return this.mFormManagerLastShowFrom;
  }

  /**
   * Update the extend1 in rdb by cardId.
   *
   * @param {string} extend1
   * @param {string} cardId
   * @return {boolean} result
   */
  async updateExtend1ByCardId(extend1: string, cardId: string): Promise<boolean> {
    return await this.mRdbStoreManager.updateExtend1ByCardId(extend1, cardId);
  }

  public deleteCardDescriptionCache(bundleName: string): void {
    let bundleFormsInfoList: CardItemInfo[] | undefined = this.mAppItemFormInfoMap.get(bundleName);
    if (!bundleFormsInfoList || CheckEmptyUtils.isEmptyArr(bundleFormsInfoList)) {
      return;
    }
    bundleFormsInfoList.forEach((cardItemInfo) => {
      this.mFormManager.clearCardDescriptionCache(cardItemInfo.descriptionId, cardItemInfo.bundleName,
        cardItemInfo.moduleName);
      this.mFormManager.clearCardDescriptionCache(cardItemInfo.displayNameId, cardItemInfo.bundleName,
        cardItemInfo.moduleName);
    });
  }

  public isFormCenterSupportCard(item: CardItemInfo): boolean {
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showError('isFormCenterSupportCard invalid parameter');
      return false;
    }
    if (item.renderingMode === CommonConstants.CARD_RENDERING_MODE_SINGLE_COLOR) {
      log.showInfo(`card not support singleColor rendering mode, bundleName:${item.bundleName}`);
      return false;
    }
    if (launcherStatusUtil.getShowOutLauncherStatus() && item.isOuterHomeDisable) {
      log.showInfo(`card not support in outer screen, bundleName:${item.bundleName}`);
      return false;
    }
    log.showDebug(`card renderingMode is : ${item.renderingMode}, bundleName: ${item.bundleName},` +
      `cardName: ${item.cardName}`);
    return item.showInCenter && this.isSupportCard(item.cardDimension);
  }

  public isSupportCard(cardDimension: number): boolean {
    if (cardDimension === CommonConstants.CARD_DIMENSION_1x1) {
      return false;
    }
    if (cardDimension === CommonConstants.CARD_DIMENSION_6x4) {
      return GridLayoutUtil.isSupportLargeForm(cardDimension);
    }
    return true;
  }

  public isScreenLockSupportCard(formInfo: CardItemInfo): boolean {
    if (CheckEmptyUtils.isEmpty(formInfo)) {
      log.showError('isScreenLockSupportCard invalid parameter');
      return false;
    }

    if (!this.isScreenLockSupportDimension(formInfo.cardDimension)) {
      return false;
    }

    log.showDebug(`card renderingMode is : ${formInfo.renderingMode}, bundleName: ${formInfo.bundleName},` +
      `cardName: ${formInfo.cardName}`);

    // 保留历史白名单，取旧白名单以及新白名单校验renderingMode的并集
    return SCREEN_LOCK_FORM_WHITE_LIST.includes(formInfo.bundleName) ||
      this.isPassedWhiteListVerify(formInfo.bundleName, formInfo.renderingMode);
  }

  private isPassedWhiteListVerify(name: string, renderingMode: number): boolean {
    //仅打桩验证 后续删除
    let tempName = systemParameter.getSync('whiteList', '');
    if (!CheckEmptyUtils.isEmpty(tempName) && !this.newScreenLockWhiteList.includes(tempName)) {
      this.newScreenLockWhiteList.push(tempName);
    }

    if (renderingMode !== CommonConstants.CARD_RENDERING_MODE_FULL_COLOR &&
    this.newScreenLockWhiteList.includes(name)) {
      return true;
    }
    return false;
  }

  private removeBundleFromAppList(bundleName: string): void {
    let index: number = this.mFormsAppList.findIndex(appInfo => appInfo.bundleName === bundleName);
    if (index !== -1) {
      this.mFormsAppList.splice(index, 1);
      log.showInfo(`remove from suppport form app list, bundle: ${bundleName}`);
    }
  }

  private removeScreenLockPermission(bundleName: string): void {
    if (NEW_SCREEN_LOCK_FORM_WHITE_LIST.includes(bundleName)) {
      return;
    }
    let index: number = this.newScreenLockWhiteList.indexOf(bundleName);
    if (index !== -1) {
      this.newScreenLockWhiteList.splice(index, 1);
      log.showInfo(`remove screenk lock white list, bundle: ${bundleName}`);
    }
  }

  private addScreenLockPermission(bundleName: string): void {
    let index: number = this.newScreenLockWhiteList.indexOf(bundleName);
    if (index === -1) {
      this.newScreenLockWhiteList.push(bundleName);
      log.showInfo(`add screenk lock white list, bundle: ${bundleName}`);
    }
  }

  private isNeedCheckScreenLockPermission(bundleName: string): boolean {
    let cardItemInfos: CardItemInfo[] = this.mAppItemFormInfoMap.get(bundleName) ?? [];
    return cardItemInfos.some((cardItemInfo: CardItemInfo) => {
      return cardItemInfo.renderingMode !== CommonConstants.CARD_RENDERING_MODE_FULL_COLOR &&
      this.isScreenLockSupportDimension(cardItemInfo.cardDimension) &&
        !SCREEN_LOCK_FORM_WHITE_LIST.includes(cardItemInfo.bundleName) &&
        !NEW_SCREEN_LOCK_FORM_WHITE_LIST.includes(cardItemInfo.bundleName);
    });
  }

  private async checkScreenLockPermission(bundleName: string): Promise<boolean> {
    let isGranted: boolean = false;
    try {
      let bundleFlags: number = bundleManager.AbilityFlag.GET_ABILITY_INFO_DEFAULT;
      let bundleInfo: bundleManager.ApplicationInfo = bundleManager.getApplicationInfoSync(bundleName, bundleFlags);

      if (!bundleInfo || !bundleInfo.uid) {
        log.showError(`${bundleName} does not have uid`);
        return false;
      }

      // let result: cloudCapabilityManager.CloudCapabilityStatus[] =
      //   await cloudCapabilityManager.verifyCloudCapability(bundleInfo.uid, [SCREEN_LOCK_AGC_PERMISSION_NAME]);
      // isGranted = result[0] === cloudCapabilityManager.CloudCapabilityStatus.GRANTED;
    } catch (err) {
      log.showError(`update ${bundleName} permission error: ${err?.code}, ${err?.message}`);
    }
    return isGranted;
  }

  private async updateScreenLockWhiteList(bundleName: string): Promise<void> {
    if (!this.isNeedCheckScreenLockPermission(bundleName)) {
      return;
    }

    let isGranted: boolean = await this.checkScreenLockPermission(bundleName);
    log.showWarn(`verifyCloudCapability, bundle: ${bundleName}, result: ${isGranted}`);
    if (isGranted) {
      this.addScreenLockPermission(bundleName);
    } else {
      this.removeScreenLockPermission(bundleName);
    }
  }

  private isScreenLockSupportDimension(cardDimension: number): boolean {
    return cardDimension === CommonConstants.CARD_DIMENSION_1x1 || cardDimension === CommonConstants.CARD_DIMENSION_1x2;
  }

  public isSystemApp(bundleName: string): boolean {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      return false;
    }
    // 打桩验证，后续版本删除
    let isNeedVerify = systemParameter.getSync('isNeedVerify', 'true');
    if (isNeedVerify !== 'true') {
      return true;
    }
    try {
      let applicationInfo = bundleManager.getApplicationInfoSync(bundleName,
        bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT);
      if (applicationInfo && applicationInfo.systemApp) {
        return true;
      }
    } catch (error) {
      log.showError(`call isSystemApp error, code: ${error?.code}, message: ${error?.message}`);
    }
    return false;
  }

  public isSupportFormCenterSplit(): boolean {
    // 目前支持分栏样式设备,大折叠展开态、PAD、PC、三折叠G态和M态
    if (DeviceHelper.isThreeFoldProduct()) {
      return DeviceHelper.isGState() || DeviceHelper.isMState();
    }
    if (DeviceHelper.isPad() || DeviceHelper.isPC() ||
      (DeviceHelper.isFoldExpandedOrHalf())) {
      return true;
    }
    return false;
  }

  public isSupportCreateFormAnimate(): boolean {
    if (DeviceHelper.isPC()) {
      return false;
    }
    return true;
  }

  /**
   * 判断卡片Id是否无效.
   *
   * @param {string} cardId
   * @return {boolean} result
   */
  public isCardIdInvalid(cardId: string): boolean {
    return CheckEmptyUtils.checkStrIsEmpty(cardId) || cardId === '0';
  }

  /**
   * 根据id判断卡片或堆叠是否在布局中存在
   *
   * @returns 是否在布局中存在
   */
  public existCardId(cardId: string, layoutList: GridLayoutItemInfo[]): boolean {
    return layoutList.some(layout => {
      if (layout.typeId === CommonConstants.TYPE_CARD) {
        return cardId === layout.cardId;
      } else if (layout.typeId === CommonConstants.TYPE_FORM_STACK) {
        return layout.layoutInfo?.[0].some(layoutItem => cardId === layoutItem.cardId) ||
          cardId === layout.formStackId;
      }
      return false;
    });
  }

  /**
   * 根据id判断卡片是否属于外屏堆叠
   *
   * @returns 是否属于外屏堆叠
   */
  public isCardInOuterStack(cardId: string, layoutList: GridLayoutItemInfo[]): boolean {
    if (CheckEmptyUtils.isEmptyArr(layoutList)) {
      return false;
    }
    return layoutList.some(layout => {
      if (layout.typeId === CommonConstants.TYPE_FORM_STACK) {
        return layout.layoutInfo?.[0].some(layoutItem => cardId === layoutItem.cardId);
      }
      return false;
    });
  }

  public async getCardCloneStatus(layoutItem: GridLayoutItemInfo, bundleNameSet: Set<String>): Promise<number> {
    if (CheckEmptyUtils.isEmpty(layoutItem) || CheckEmptyUtils.isEmpty(bundleNameSet)) {
      log.showWarn('layoutItem is empty: %{public}s, appList is empty: %{public}s', CheckEmptyUtils.isEmpty(layoutItem),
        CheckEmptyUtils.isEmpty(bundleNameSet));
      return CardCloneStatus.PARAMS_ERROR;
    }

    return this.checkNormalCard(layoutItem, bundleNameSet);
  }

  private async checkNormalCard(layoutItem: GridLayoutItemInfo, bundleNameSet: Set<String>): Promise<number> {
    if (FormRelationManager.getInstance().isSceneBoardCard(layoutItem.bundleName, layoutItem.cardName)) {
      // 不克隆旧机占位卡
      log.showWarn('placeholder card not surrprt clone');
      return CardCloneStatus.ABNORMAL_WITHOUT_CARD;
    }
    const cards: CardItemInfo[] = await this.getFormsInfoByBundleName(layoutItem.bundleName);
    if (CheckEmptyUtils.isEmptyArr(cards)) {
      // 不具备添加bundleName应用所对应的一类卡片的能力
      log.showWarn(`There is no card of bundleName : ${layoutItem.bundleName} installed`);
      if (bundleNameSet.has(layoutItem.bundleName)) {
        // 不支持这张卡片，新机上有应用，删卡
        log.showInfo(`card ${layoutItem.bundleName} can not clone to the new device`)
        return CardCloneStatus.ABNORMAL_WITHOUT_CARD;
      }
      // 不支持这张卡片，新机上无应用: 1、应用还没恢复; 2、旧机没有恢复的占位卡。形成占位卡
      log.showInfo(`app ${layoutItem.bundleName} do not install on the new device`);
      return CardCloneStatus.ABNORMAL_WITHOUT_APP;
    }
    // 具备添加bundleName应用所对应的一类卡片的能力
    let cardDimension: number = CardItemInfo.getCardDimension(layoutItem.area);
    let isCardInstalled: boolean = cards.some((card: CardItemInfo) => {
      return card.bundleName === layoutItem.bundleName &&
        card.moduleName === layoutItem.moduleName &&
        card.abilityName === layoutItem.abilityName &&
        card.cardName === layoutItem.cardName &&
        (card.supportDimensions.some((item: number) => item === cardDimension));
    });
    if (!isCardInstalled) {
      log.showWarn('No card install, bundlename: %{public}s, moduleName: %{public}s, abilityName: %{public}s, cardName: %{public}s, cardDimension: %{public}d',
        layoutItem.bundleName, layoutItem.moduleName, layoutItem.abilityName, layoutItem.cardName, cardDimension);
      return CardCloneStatus.ABNORMAL_WITHOUT_CARD;
    }
    return CardCloneStatus.NORMAL;
  }

  public registerGetFromRectInfoCallback(): void {
    let getFormRectInfoCallback: formInfo.GetFormRectInfoCallback =
      (formId: string): Promise<formInfo.Rect> => {
        return new Promise(async (resolve: Function, reject: Function) => {
          log.showInfo(`getFormRectInfoCallback: Callback start - formId: ${formId}`);
          if (CheckEmptyUtils.isEmpty(formId)) {
            reject();
            return;
          }
          let result = this.getFormRect(formId);
          log.showDebug(`getFormRectInfoCallback: result is empty: ${CheckEmptyUtils.isEmpty(result)}`);
          if (CheckEmptyUtils.isEmpty(result)) {
            reject();
            return;
          }
          resolve(result);
          return;
        })
      };
    log.showInfo('registerGetFromRectInfoCallback');
    try {
      formHost.on('getFormRect', getFormRectInfoCallback);
    } catch (error) {
      log.showError(`registerGetFromRectInfoCallback failed, code is ${error?.code}, message is ${error?.message}`);
    }
  }

  public unregisterGetFromRectInfoCallback(): void {
    log.showInfo('unregisterGetFromRectInfoCallback');
    try {
      formHost.off('getFormRect');
    } catch (error) {
      log.showError(`unregisterGetFromRectInfoCallback failed, code is ${error?.code}, message is ${error?.message}`);
    }
  }

  private getFormRect(formId: string): formInfo.Rect | undefined {
    let isOuterDisplay = launcherStatusUtil.getShowOutLauncherStatus();
    const allLayoutInfo: GridLayoutItemInfo[] = this.mFormLayoutManager.getAllGridLayoutItemList(
      BusinessType.BUSINESS_CARD, isOuterDisplay);
    if (CheckEmptyUtils.isEmpty(allLayoutInfo)) {
      log.showInfo('getFormRect, allLayoutInfo is empty');
      return undefined;
    }
    let layoutInfo: GridLayoutItemInfo | undefined = allLayoutInfo.find(item => item.cardId === formId);
    if (!layoutInfo) {
      log.showInfo('getFormRect, layoutInfo is empty');
      return undefined;
    }
    let formComponentId: string = FormCommonUtil.getFormComponentId(layoutInfo);
    let formComponentBuilderId: string = formComponentId + `column`;
    return FormCommonUtil.getFormRect(formComponentBuilderId);
  }
}