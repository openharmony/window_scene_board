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

import { Want } from '@kit.AbilityKit';
import formManagerAbility from '@ohos.app.form.formHost';
import formInfo from '@ohos.app.form.formInfo';
import {
  CheckEmptyUtils,
  DomainName,
  LogDomain,
  LogHelper,
  // MemoryUtils,
  TaskpoolUtil,
  TraceUtil
} from '@ohos/basicutils';
import { GlobalContext, ResourceManager } from '@ohos/frameworkwrapper';
import type ctx from '@ohos.app.ability.common';
import type resourceManager from '@ohos.resourceManager';
import { CardItemInfo } from '../bean/CardItemInfo';
import { CommonConstants } from '../constants/CommonConstants';
import { launcherAbilityManager } from '../abilitymanager/LauncherAbilityManager';
import { FormConstants } from '../constants/FormConstants';
import { FullScreenCardUtil } from '../form/model/FullScreenCardUtil';
import { OverflowFormInfoUtil } from '../utils/OverflowFormInfoUtil';
import CardLockManager from './CardLockManager';
import { FormLayoutCacheManager } from '../cache/layout/FormLayoutCacheManager';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { CardNodeControllerManager } from '../manager/CardNodeControllerManager';
import { AppItemInfo } from '../bean/AppItemInfo';
import { AppModel } from '../model/AppModel';

const TAG = 'FormManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const CARD_SIZE_SMALL_LENGTH: number = 1;
const CARD_SIZE_MIDDLE_LENGTH: number = 2;
const CARD_SIZE_LARGE_LENGTH: number = 4;
const CARD_SIZE_LARGER_LENGTH: number = FullScreenCardUtil.getInstance().getRow();

/**
 * Wrapper class for formManager interfaces.
 */
export class FormManager {
  private readonly CARD_SIZE_ONE_ONE: number[] = [CARD_SIZE_SMALL_LENGTH, CARD_SIZE_SMALL_LENGTH];
  private readonly CARD_SIZE_ONE_TWO: number[] = [CARD_SIZE_MIDDLE_LENGTH, CARD_SIZE_SMALL_LENGTH];
  private readonly CARD_SIZE_TWO_TWO: number[] = [CARD_SIZE_MIDDLE_LENGTH, CARD_SIZE_MIDDLE_LENGTH];
  private readonly CARD_SIZE_ONE_FOUR: number[] = [CARD_SIZE_LARGE_LENGTH, CARD_SIZE_SMALL_LENGTH];
  private readonly CARD_SIZE_TWO_FOUR: number[] = [CARD_SIZE_LARGE_LENGTH, CARD_SIZE_MIDDLE_LENGTH];
  private readonly CARD_SIZE_FOUR_FOUR: number[] = [CARD_SIZE_LARGE_LENGTH, CARD_SIZE_LARGE_LENGTH];
  private readonly CARD_SIZE_SIX_FOUR: number[] = [CARD_SIZE_LARGE_LENGTH, CARD_SIZE_LARGER_LENGTH];
  private readonly mResourceManager: ResourceManager;

  private constructor() {
    this.mResourceManager = ResourceManager.getInstance();
  }
  /**
   * form manager instance
   *
   * @return formManager instance
   */
  static getInstance(): FormManager {
    if (globalThis.FormManagerInstance == null) {
      globalThis.FormManagerInstance = new FormManager();
    }
    return globalThis.FormManagerInstance;
  }

  /**
   * get all form info
   *
   * @return Array<CardItemInfo> cardItemInfoList
   */
  async getAllFormsInfo(): Promise<CardItemInfo[]> {
    await formManagerAbility.isSystemReady().then(() => {
      log.showDebug('getAllFormsInfo formHost system is ready');
    }).catch((error: Error) => {
      log.error('getAllFormsInfo formHost isSystemReady error:', error);
    });

    const cardItemInfoList = new Array<CardItemInfo>();
    try {
      const formList = await formManagerAbility.getAllFormsInfo();
      TraceUtil.startTrace(DomainName.SCB, TraceUtil.CORE_METHOD_QUERY_ALL_FORM);
      log.showInfo(`getAllFormsInfo length:${formList?.length}`);
      for (const formItem of formList) {
        if (formItem.supportedShapes.length === 1 &&
        formItem.supportedShapes?.some((value) => {
          return value === formInfo.FormShape.CIRCLE;
        })) {
          log.showInfo(`getAllFormsInfo split circle card item :${formItem.bundleName}`);
          continue;
        }
        let cardItemInfo: CardItemInfo = new CardItemInfo();
        this.convertFormInfo(cardItemInfo, formItem);
        cardItemInfoList.push(cardItemInfo);
      }
    } catch (error) {
      log.error('getAllFormsInfo error:', error);
    }
    TraceUtil.endTrace(DomainName.SCB, TraceUtil.CORE_METHOD_QUERY_ALL_FORM);
    return cardItemInfoList;
  }

  private shouldShowInCenter(formItem: formInfo.FormInfo): boolean {
    if (String(formItem?.customizeData?.isShowInFormCenter) !== 'false') {
      return true;
    }

    // 如果是桌面已存在卡片，卡片配置在卡片中心不显示，长按菜单更多卡片动效异常，需要继续在卡片中心显示
    if (this.isShowInDesktop(formItem)) {
      log.showInfo(`shouldShowInCenter ${formItem.bundleName}_${formItem.name} isShowInDesktop`);
      return true;
    }
    return false;
  }

  private isShowInDesktop(formItem: formInfo.FormInfo): boolean {
    const formList = FormLayoutCacheManager.getInstance().selectGridLayoutItemsByBundleName(formItem?.bundleName);
    if (CheckEmptyUtils.isEmptyArr(formList)) {
      return false;
    }

    const targetForm = formList.filter(Boolean).find((itemInfo: GridLayoutItemInfo) => {
      return itemInfo.moduleName === formItem.moduleName && itemInfo.abilityName === formItem.abilityName &&
        itemInfo.cardName === formItem.name;
    });
    return !CheckEmptyUtils.isEmpty(targetForm);
  }

  private getCardRenderingMode(renderingMode: number, metaData?: string): number {
    if (!CheckEmptyUtils.isEmpty(metaData)) {
      return Number(metaData);
    }
    if (CheckEmptyUtils.isEmpty(renderingMode)) {
      return CommonConstants.CARD_RENDERING_MODE_FULL_COLOR;
    }
    return renderingMode;
  }

  async getCardDescription(description: string, descriptionId: number, bundleName: string,
    moduleName: string): Promise<string> {
    if (Number.isNaN(descriptionId) || descriptionId <= 0) {
      log.showInfo(`getCardDescription getString error! descriptionId is ${descriptionId}`);
      return description;
    }
    const cacheKey = `${descriptionId}${bundleName}${moduleName}`;
    const cardDescription: string = this.mResourceManager.getAppResourceCache(cacheKey, 'CardDescription') as string;
    if (!CheckEmptyUtils.isEmpty(cardDescription)) {
      return cardDescription;
    }
    try {
      let resMgr: resourceManager.ResourceManager = (GlobalContext.getInstance().getObject('desktopContext') as
        ctx.ServiceExtensionContext).createModuleResourceManager(bundleName, moduleName);
      let value: string = resMgr && await resMgr.getString(descriptionId);
      // MemoryUtils.removeNapiWrap(resMgr, false);
      if (CheckEmptyUtils.checkStrIsEmpty(value)) {
        log.showInfo(`getCardDescription getString is empty! descriptionId is ${descriptionId}`);
        return description;
      } else {
        this.mResourceManager.setAppResourceCache(cacheKey, 'CardDescription', value);
        return value;
      }
    } catch (err) {
      log.error('getCardDescription error:', err);
      return description;
    }
  }

  public clearCardDescriptionCache(id: number, bundleName: string, moduleName: string): void {
    log.showInfo(`clearCardDescriptionCache ${bundleName}`);
    if (Number.isNaN(id) || id <= 0) {
      log.showInfo(`invalid id：${id}`);
      return;
    }
    const cacheKey = `${id}${bundleName}${moduleName}`;
    this.mResourceManager.deleteAppResourceCache(cacheKey, 'name');
  }

  getCardSize(dimension: number, isFormDimension1x4?: boolean): number[] {
    if (isFormDimension1x4) {
      return this.CARD_SIZE_ONE_FOUR;
    }
    if (dimension === CommonConstants.CARD_DIMENSION_1x2) {
      return this.CARD_SIZE_ONE_TWO;
    } else if (dimension === CommonConstants.CARD_DIMENSION_2x2) {
      return this.CARD_SIZE_TWO_TWO;
    } else if (dimension === CommonConstants.CARD_DIMENSION_2x4) {
      return this.CARD_SIZE_TWO_FOUR;
    } else if (dimension === CommonConstants.CARD_DIMENSION_4x4) {
      return this.CARD_SIZE_FOUR_FOUR;
    } else if (dimension === CommonConstants.CARD_DIMENSION_6x4) {
      return this.CARD_SIZE_SIX_FOUR;
    } else if (dimension === CommonConstants.CARD_DIMENSION_1x1) {
      return this.CARD_SIZE_ONE_ONE;
    } else {
      log.showError(`FormManager getCardSize by dimension failed, wrong dimension: ${dimension}`);
      return this.CARD_SIZE_TWO_TWO;
    }
  }

  private convertFormInfo(cardItemInfo: CardItemInfo, formItem: formInfo.FormInfo): void {
    cardItemInfo.bundleName = formItem.bundleName;
    cardItemInfo.abilityName = formItem.abilityName;
    cardItemInfo.moduleName = formItem.moduleName;
    cardItemInfo.cardName = formItem.name;
    cardItemInfo.cardDimension = formItem.defaultDimension;
    cardItemInfo.displayNameId = formItem.displayNameId;
    cardItemInfo.descriptionId = formItem.descriptionId;
    cardItemInfo.formConfigAbility = formItem.formConfigAbility;
    OverflowFormInfoUtil.fillOverflowCardInfo(formItem, cardItemInfo);
    cardItemInfo.supportDimensions = formItem.supportDimensions;
    cardItemInfo.isOuterHomeDisable =
      (formItem.customizeData?.isOuterHomeDisable ?? 'false') === 'true' ? true : false;
    cardItemInfo.renderingMode =
      this.getCardRenderingMode(formItem.renderingMode, formItem.customizeData.renderingMode);
    // 仅系统应用支持1x4卡片
    let appInfo: AppItemInfo | undefined = AppModel.getInstance().getAppInfoByBundleName(formItem.bundleName);
    if (appInfo && appInfo.isSystemApp) {
      cardItemInfo.isFormDimension1x4 =
        (formItem.customizeData?.isFormDimension1x4 ?? 'false') === 'true' ? true : false;
    }
    if (!this.shouldShowInCenter(formItem)) {
      cardItemInfo.showInCenter = false;
    }

    if (String(formItem?.customizeData?.defaultActivated) === 'true') {
      cardItemInfo.isDefaultActivated = true;
    }

    cardItemInfo.isTransparent = formItem.transparencyEnabled;
    cardItemInfo.enableBlurBgr = formItem.enableBlurBackground;
    cardItemInfo.resizable = formItem.resizable;
    cardItemInfo.groupId = formItem.groupId;
    if (formItem.isDefault) {
      cardItemInfo.isDefaultCardDimension = formItem.defaultDimension;
    }
    // 1*4卡片需要前置参数赋值后才能获取area
    cardItemInfo.area = this.getCardSize(cardItemInfo.cardDimension, cardItemInfo.isFormDimension1x4);
  }

  /**
   * get form info by bundleName
   *
   * @param bundle
   */
  async getFormsInfoByApp(bundle: string): Promise<CardItemInfo[]> {
    log.showInfo(`getFormsInfoByApp bundle: ${bundle}`);
    await formManagerAbility.isSystemReady().then(() => {
      log.showDebug('getFormsInfoByApp formHost system is ready');
    }).catch((error: Error) => {
      log.error('getFormsInfoByApp formHost isSystemReady error:', error);
    });

    const formFilter: formInfo.FormInfoFilter = {
      bundleName: bundle
    };

    const cardItemInfoList = new Array<CardItemInfo>();
    try {
      const formList = await formManagerAbility.getFormsInfo(formFilter);
      TraceUtil.startTrace(DomainName.SCB, TraceUtil.CORE_METHOD_QUERY_APP_FORM);
      for (const formItem of formList) {
        let cardItemInfo: CardItemInfo = new CardItemInfo();
        this.convertFormInfo(cardItemInfo, formItem);
        cardItemInfoList.push(cardItemInfo);
      }
    } catch (error) {
      log.error('getAllFormsInfo error:', error);
    }
    TraceUtil.endTrace(DomainName.SCB, TraceUtil.CORE_METHOD_QUERY_APP_FORM);
    return cardItemInfoList;
  }

  /**
   * get cardItemInfo by want parameters
   *
   * @param parameters
   * @return cardItemInfo
   */
  async getFormCardItemByWant(tParams: Record<string, Object>): Promise<CardItemInfo> {
    if (CheckEmptyUtils.isEmpty(tParams)) {
      log.showError('getFormCardItemByWant params is empty!');
      return new CardItemInfo();
    }
    let params: Record<string, string> = tParams as Record<string, string>;
    log.showInfo('getFormCardItemByWant');
    let cardItemInfo: CardItemInfo = new CardItemInfo();
    cardItemInfo.cardId = params[FormConstants.ID_PARAM];
    cardItemInfo.id = cardItemInfo.cardId;
    cardItemInfo.name = params[FormConstants.NAME_PARAM];
    cardItemInfo.bundleName = params[FormConstants.BUNDLE_PARAM];
    cardItemInfo.abilityName = params[FormConstants.ABILITY_PARAM];
    cardItemInfo.moduleName = params[FormConstants.MODULE_PARAM];
    cardItemInfo.dimension = Number(params[FormConstants.DIMENSION_PARAM]);
    cardItemInfo.cardDimension = cardItemInfo.dimension;
    cardItemInfo.callerBundle = params[FormConstants.CALLER_BUNDLE_PARAM];
    await this.updateFormConfig(params[FormConstants.BUNDLE_PARAM], params[FormConstants.NAME_PARAM], cardItemInfo);
    cardItemInfo.appLabelId = await launcherAbilityManager.getAppLabelId(params[FormConstants.BUNDLE_PARAM]);
    return cardItemInfo;
  }

  /**
   * get app form extra information by want parameters
   *
   * @param params
   * @return AppFormWantParamInterface
   */
  async getAppFormWantParamInterface(tParams: Record<string, Object>): Promise<AppFormWantParamInterface> {
    if (CheckEmptyUtils.isEmpty(tParams)) {
      log.showError('getAppFormWantParamInterface params is empty!');
      return {} as AppFormWantParamInterface;
    }
    let params = tParams as Record<string, string>;
    log.showInfo(`getAppFormWantParamInterface, appFormScreenX: ${params[FormConstants.APP_FORM_SCREEN_X]},
    appFormScreenY: ${params[FormConstants.APP_FORM_SCREEN_Y]},
    appFormWidth: ${params[FormConstants.APP_FORM_WIDTH]},
    appFormHeight: ${params[FormConstants.APP_FORM_HEIGHT]}`);
    return {
      appFormSnapshot: params[FormConstants.APP_FORM_SNAPSHOT],
      appFormWidth: Number(params[FormConstants.APP_FORM_WIDTH]),
      appFormHeight: Number(params[FormConstants.APP_FORM_HEIGHT]),
      appFormScreenX: Number(params[FormConstants.APP_FORM_SCREEN_X]),
      appFormScreenY: Number(params[FormConstants.APP_FORM_SCREEN_Y])
    };
  }

  /**
   * update formConfigAbility and isTransparent by bundleName and cardName
   *
   * @param bundle
   * @param cardName
   * @param formCardItem
   */
  async updateFormConfig(bundle: string, cardName: string, cardItemInfo: CardItemInfo): Promise<void> {
    const formList = await formManagerAbility.getFormsInfo(bundle);
    for (const formItem of formList) {
      if (formItem.name === cardName) {
        cardItemInfo.formConfigAbility = formItem.formConfigAbility;
        cardItemInfo.isTransparent = formItem.transparencyEnabled;
        cardItemInfo.enableBlurBgr = formItem.enableBlurBackground;
        cardItemInfo.resizable = formItem.resizable;
        cardItemInfo.groupId = formItem.groupId;
        if (formItem.isDefault) {
          cardItemInfo.isDefaultCardDimension = formItem.defaultDimension;
        }
        OverflowFormInfoUtil.fillOverflowCardInfo(formItem, cardItemInfo);
        break;
      }
    }
  }

  /**
   * get form info by bundleName and moduleName
   *
   * @param bundleName
   * @param moduleName
   */
  async getFormsInfo(bundleName: string, moduleName: string): Promise<formInfo.FormInfo[] | undefined> {
    await formManagerAbility.isSystemReady().then(() => {
      log.showDebug('getFormsInfo formHost system is ready');
    }).catch((error: Error) => {
      log.error('getFormsInfo formHost isSystemReady error:', error);
    });

    let formList: formInfo.FormInfo[] | undefined;
    try {
      formList = await formManagerAbility.getFormsInfo(bundleName, moduleName);
    } catch (err) {
      log.showError(`getFormsInfo failed bundleName: ${bundleName}, errorCode ${err?.code}`);
    }
    return formList;
  }

  private deleteNoUsedFormByTask(formId: string): void {
    TaskpoolUtil.doTask(deleteNoUsedFormId, formId);
  }

  /**
   * add form info
   *
   * @param want
   */
  async addCard(want: Want): Promise<formInfo.RunningFormInfo> {
    let formInfo: formInfo.RunningFormInfo;
    try {
      formInfo = await formManagerAbility.addForm(want);
      log.showDebug('addCard formHost addForm is ok.');
    } catch (error) {
      log.error('addCard formHost addFrom error:', error);
    }
    return formInfo;
  }

  /**
   * delete form info by formId
   *
   * @param formId
   */
  async deleteCard(formId: string, isNeedDelFrameForm: boolean = true): Promise<void> {
    log.showInfo(`formManager delete card, cardId is: ${formId}`);
    // 删除卡片锁中的缓存
    CardLockManager.getInstance().deleteCacheByCardId(formId);
    // 删除复用节点
    CardNodeControllerManager.destroyNodeByCardId(formId);
    if (isNeedDelFrameForm) {
      this.deleteNoUsedFormByTask(formId);
    }
  }

  /**
   * Converts a specified temporary form that has been obtained by the application into a normal form.
   *
   * @param formId
   */
  async castTempForm(formId: string): Promise<void> {
    return await formManagerAbility.castToNormalForm(formId);
  }
  /**
   * Set publish form result by formId
   *
   * @param formId
   * @param errorCode
   */
  setPublishFormResult(formId: string, errorCode: number): void {
    log.showInfo(`Set publish form result by formId, formId is: ${formId}`);
    let message: string = '';
    switch (errorCode) {
      case formInfo.PublishFormErrorCode.SUCCESS:
        message = 'add form success.';
        break;
      case formInfo.PublishFormErrorCode.NO_SPACE:
        message = 'add form fail, desktop card exceed limit or desktop exceed max page.';
        break;
      case formInfo.PublishFormErrorCode.PARAM_ERROR:
        message = 'add form fail, param is invalid.';
        break;
      default:
        message = 'add form fail, other reason.';
        break;
    }
    formManagerAbility.setPublishFormResult(formId,
      {
        code: errorCode,
        message: message
      });
  }
}

function deleteNoUsedFormId(formId: string): void {
  'use concurrent';
  const TAG = 'FormManager';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  try {
    formManagerAbility.deleteForm(formId);
  } catch (error) {
    log.error('deleteNoUsedFormId formManagerAbility error: ', error);
  }
}

/**
 * Defines the app form extra parameter.
 *
 * @interface AppFormWantParamInterface
 */
export interface AppFormWantParamInterface {
  appFormSnapshot: string;
  appFormWidth: number;
  appFormHeight: number;
  appFormScreenX: number;
  appFormScreenY: number;
}