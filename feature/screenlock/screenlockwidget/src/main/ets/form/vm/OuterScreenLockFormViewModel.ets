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

import type { LockscreenFormConfig } from '../../common/WidgetParam';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import ScreenLockFormProxyManager from './ScreenLockFormProxyManager';
import { ScreenLockFormManagerUtil } from '@ohos/screenlockcommon/Index';
import Want from '@ohos.app.ability.Want';
import { BaseViewModel } from '@ohos/screenlockcommon/Index';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { systemDateTime } from '@kit.BasicServicesKit';

const TAG = 'OuterScreenLockFormViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const DIMENSION_X_OF_EMPTY_FORM: number = 0;
const DIMENSION_X_OF_1X2_FORM: number = 2;
const SCREEN_LOCK: number = 6;
const FORM_LOCATION_KEY = 'ohos.extra.param.key.form_location';
const POSITION_X_ZERO = 0;
const POSITION_X_TWO = 2;
const POSITION_X_THREE = 3;
const CAMERA_BUNDLE_NAME = 'com.ohos.camera';

export default class OuterScreenLockFormViewModel extends BaseViewModel {
  // 组件透明度
  public formComponentOpacity: number = 1;
  // from的位置及信息
  public formConfigs: LockscreenFormConfig[] = [];
  public toBeDelCardIDS: string[] = [];
  private proxyManager: ScreenLockFormProxyManager = new ScreenLockFormProxyManager();
  private destroyedFormCardIds: string[] = [];
  private isDestroyedForm: boolean = false;

  /**
   * ScreenLockForm
   *
   * @param want 卡片配置参数
   */
  public static getFromWant(): Want {
    let want: Want = {};
    want.parameters = {};
    want.parameters[FORM_LOCATION_KEY] = SCREEN_LOCK;
    return want;
  }

  public registerRouterProxy(formId: string): void {
    if (!this.proxyManager) {
      return;
    }
    this.proxyManager.registerRouterProxy(formId);
  }

  /**
   *  获取外屏卡片数组长度
   */
  public getOuterFormLen(): boolean {
    log.showDebug(`getOuterFormLen, this.formConfigs.length = ${this.formConfigs.length}`);
    return this.formConfigs.length > 0;
  }

  public updateFormId(index: number, formId: string): void {
    if (!this.formConfigs || index >= this.formConfigs.length) {
      log.showError(`updateFormId, index is out of bounds: ${index}`);
      return;
    }
    let cardInfo = this.formConfigs[index];
    if (!cardInfo || cardInfo.formInfo.cardId === formId) {
      return;
    }
    cardInfo.formInfo.cardId = formId;
  }

  public viewModelInitOnScreenLock(formConfigs: LockscreenFormConfig[]): void {
    log.showInfo(`viewModelInitOnScreenLock, formConfigs = ${this.printFormConfig(formConfigs)}`);
    // 当前正在使用的id
    formConfigs = this.initFormConfigs(formConfigs);
    formConfigs = this.handleHisFormConfig(formConfigs);
    this.initFormConfigInfo(formConfigs);
  }

  /**
   *  删除历史不需要的卡片， 并把新卡片ID设置成0，准备新建
   *
   * @param formConfigs
   * @returns
   */
  private initFormConfigs(formConfigs: LockscreenFormConfig[]) {
    formConfigs.sort((a, b) => a.positionX - b.positionX);
    let isSameCard: boolean = this.isTheSameCardConfig(formConfigs);
    if (!isSameCard) {
      this.clearUnUsedFormConfigs(this.formConfigs);
      if (this.formConfigs.length === 0) {
        let nextUsingCardIds: string[] = this.getCardIdsFromFormConfig(formConfigs);
        ObjectCopyUtil.deepClone(nextUsingCardIds, this.destroyedFormCardIds);
      } else {
        this.destroyedFormCardIds = [];
      }
      formConfigs = formConfigs.map((currentItem: LockscreenFormConfig) => {
        currentItem.formInfo.cardId = '0';
        currentItem.formInfo.tempId = systemDateTime.getTime(true).toString();
        return currentItem;
      });
    }
    return formConfigs;
  }

  /**
   * 卡片脏数据处理,只接受positionX为1、2 的卡片信息,同时处理2位置类型为1*2的卡片,不接收相机卡片
   * @param formConfig
   * @returns
   */
  private handleHisFormConfig(formConfig: LockscreenFormConfig[]): LockscreenFormConfig[] {
    let newFormConfig: LockscreenFormConfig[] = [];
    formConfig.forEach((lockscreenFormConfig: LockscreenFormConfig) => {
      if (lockscreenFormConfig.positionX === POSITION_X_ZERO || lockscreenFormConfig.positionX === POSITION_X_THREE) {
        return;
      }
      if (lockscreenFormConfig.positionX === POSITION_X_TWO &&
        lockscreenFormConfig.dimensionX === DIMENSION_X_OF_1X2_FORM) {
        return;
      }
      if (lockscreenFormConfig.formInfo.bundleName === CAMERA_BUNDLE_NAME) {
        return;
      }
      newFormConfig.push(lockscreenFormConfig);
    })
    log.showInfo(`handleHisFormConfig, newFormConfig: ${JSON.stringify(newFormConfig)}`);
    return newFormConfig;
  }

  public initFormConfigInfo(initFormConfigs: LockscreenFormConfig[]): void {
    let isValidFormInfo: boolean = this.validateFormConfig(initFormConfigs);
    if (!isValidFormInfo) {
      this.formConfigs = [];
    } else {
      if (!this.isDestroyedForm) {
        this.formConfigs = initFormConfigs;
      }
    }
  }

  private isTheSameCardConfig(formConfigs: LockscreenFormConfig[]): boolean {
    let usingCardIds: string[] = this.getCardIdsFromFormConfig(this.formConfigs);
    // 即将使用的卡片
    let nextUsingCardIds: string[] = this.getCardIdsFromFormConfig(formConfigs);
    // 使能回调id
    let hasAllNextId: boolean = usingCardIds.every((cardId: string) => nextUsingCardIds.includes(cardId));
    let hasAllPreId: boolean = nextUsingCardIds.every((cardId: string) => usingCardIds.includes(cardId));
    this.isDestroyedForm = this.isSameCardIds(nextUsingCardIds, this.destroyedFormCardIds);
    let isSameCard: boolean = (hasAllNextId && hasAllPreId) || this.isDestroyedForm;
    return isSameCard;
  }

  private isSameCardIds(nextUsingCardIds: string[], destroyedCardIds: string[]): boolean {
    if (nextUsingCardIds.length !== destroyedCardIds.length) {
      return false;
    }
    for (let i of nextUsingCardIds) {
      if (destroyedCardIds.indexOf(i) === -1) {
        return false;
      }
    }
    return true;
  }

  private getCardIdsFromFormConfig(formConfigs: LockscreenFormConfig[]): string[] {
    return formConfigs.map((currentItem: LockscreenFormConfig) => {
      return currentItem.formInfo.cardId;
    });
  }

  /**
   *  处理卡片异常情况，删除对应cardId的formConfig
   */
  public deleteScreenLockForm(lockscreenFormConfig: LockscreenFormConfig): void {
    log.showWarn(`delete screen lock form, positionX = ${lockscreenFormConfig.positionX},` +
      `dimensionX = ${lockscreenFormConfig.dimensionX}, formId: ${lockscreenFormConfig.formInfo.id}`);
    this.deleteFromConfig(lockscreenFormConfig);
  }

  private deleteFromConfig(formInfo: LockscreenFormConfig): void {
    this.formConfigs = this.formConfigs.filter((item: LockscreenFormConfig) => {
      const samePosition: boolean = item.positionX === formInfo.positionX && item.positionY === formInfo.positionY;
      if (samePosition) {
        this.toBeDelCardIDS.push(item.formInfo.cardId);
        log.showInfo('deleteFromConfig ' + item.formInfo.cardId);
      }
      return !samePosition;
    });
  }

  public clearUnUsedFormConfigs(current: LockscreenFormConfig[] = [], pre: LockscreenFormConfig[] = []): void {
    let usingCardId: string[] = pre.map((currentItem: LockscreenFormConfig) => currentItem.formInfo.cardId);
    current.forEach((currentItem: LockscreenFormConfig) => {
      if (!usingCardId.includes(currentItem.formInfo.cardId)) {
        this.toBeDelCardIDS.push(currentItem.formInfo.cardId);
      }
    })
    this.toBeDelCardIDS.filter((cardId: string) =>!usingCardId.includes(cardId))
      .map((cardId: string) => {
        log.showInfo(`clearUnUsedFormConfig ${cardId}`);
        ScreenLockFormManagerUtil.deleteFormById(cardId);
      });
    this.toBeDelCardIDS = [];
  }

  private printFormConfig(formConfigs: LockscreenFormConfig[]): string {
    let str = '';
    formConfigs.forEach((formConfig => {
      str += this.formConfigToString(formConfig);
    }))
    return str;
  }

  private formConfigToString(formConfig: LockscreenFormConfig): string {
    return `[{"positionX": ${formConfig?.positionX},"dimensionX": ${formConfig?.dimensionX},
    "formInfo": {"cardId": ${formConfig?.formInfo?.cardId},"bundleName": ${formConfig?.formInfo?.bundleName},
    "abilityName": ${formConfig?.formInfo?.abilityName}}}]`;
  }

  private validateFormConfig(initFormConfigs: LockscreenFormConfig[]): boolean {
    if (!initFormConfigs || initFormConfigs.length === 0) {
      log.showInfo('the formConfig is empty.');
      return false;
    }
    let existInvalidFormInfo: boolean = false;
    let useCardCount: number = 0;
    initFormConfigs.forEach((formItem: LockscreenFormConfig) => {
      if (!formItem.formInfo) {
        log.showInfo('exist invalid formInfo.');
        existInvalidFormInfo = true;
      }
      if (formItem.dimensionX < DIMENSION_X_OF_EMPTY_FORM || formItem.dimensionX > DIMENSION_X_OF_1X2_FORM) {
        log.showInfo('exist invalid form, of which the size is too big.');
        existInvalidFormInfo = true;
      }
      useCardCount += (formItem?.dimensionX ?? 0);
    });
    return !existInvalidFormInfo;
  }
}