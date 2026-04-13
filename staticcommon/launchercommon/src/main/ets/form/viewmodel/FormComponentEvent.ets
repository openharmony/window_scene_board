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

import type abilityCommon from '@ohos.app.ability.common';
import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import {
  DeviceHelper,
  GlobalContext,
  localEventManager,
  FormLocationType,
} from '@ohos/frameworkwrapper';
import {
  CardItemInfo,
  CommonConstants,
  EventConstants,
  FormModel
} from '../../TsIndex';
import { LayoutViewModel } from '../../viewmodel/LayoutViewModel';
import { FormComponentModel } from '../model/FormComponentModel';
import { FormComponentVm } from './FormComponentVm';
import { FormDFXUtil } from '../../utils/FormDFXUtil';

const TAG = 'FormComponentEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormComponentEvent {
  private static readonly innerScreenRefresh = EventConstants.EVENT_REQUEST_INNER_PAGEDESK_LIGHT_REFRESH;
  private static readonly outerScreenRefresh = EventConstants.EVENT_REQUEST_OUTER_PAGEDESK_LIGHT_REFRESH;
  protected mFormModel: FormModel = FormModel.getInstance();
  protected mFormComponentVm: FormComponentVm;
  protected mFormItem: CardItemInfo = new CardItemInfo();
  protected desktopContext: abilityCommon.ServiceExtensionContext = GlobalContext.getContext();
  protected onEventhubEventHandler: Function = (isShowIcon: boolean) => this.onEventhubEvent(isShowIcon);
  protected onEventhubFsClosedEventHandler: Function = (cardId: string) => this.onEventhubFsClosedEvent(cardId);
  constructor(formComponentVm: FormComponentVm) {
    this.mFormComponentVm = formComponentVm;
  }

  initFormInfo(formItem: CardItemInfo): void {
    this.mFormItem = formItem;
  }

  public init(): void {
    if (CheckEmptyUtils.isEmpty(this.desktopContext) || CheckEmptyUtils.checkStrIsEmpty(this.mFormItem.cardId)) {
      log.showInfo('initEventhubEvent param is invalid');
      return;
    }
    let eventId: string = `${this.mFormItem.bundleName}${this.mFormItem.typeId}${this.mFormItem.cardId}`;
    this.desktopContext.eventHub.on(eventId, this.onEventhubEventHandler);
  }

  public destroy(): void {
    let eventId: string = `${this.mFormItem.bundleName}${this.mFormItem.typeId}${this.mFormItem.cardId}`;
    this.desktopContext?.eventHub.off(eventId, this.onEventhubEventHandler);
  }

  public onActive(bundleName: string) {
    log.showInfo(`onActive bundleName:${bundleName}`);
    this.setFormOpacity(0.005);
  }

  public onInactive(bundleName: string) {
    log.showInfo(`onInactive bundleName:${bundleName}`);
    this.setFormOpacity(1);
  }

  async onErrorEvent(formItem: CardItemInfo, isOuter: boolean, resultType: number, errorMsg?: string): Promise<void> {
    FormDFXUtil.reportBuildCardError(formItem, FormLocationType.DESKTOP, resultType, errorMsg);
    let formInfoList: CardItemInfo[] = await FormModel.getInstance().getFormsInfoFromMapAndManager(formItem.bundleName);
    let formBaseInfo: string = this.generateCardQuintuple(formItem);
    let formItemInApp: boolean = formInfoList.some((item) => this.generateCardQuintuple(item) === formBaseInfo);
    if (formItemInApp) {
      log.showWarn(`form item ${formBaseInfo} in bundle, no need delete`);
      return;
    }
    log.showWarn(`no form found from FMS, delete card ${formItem.cardId}`);
    this.mFormModel.deleteFormCacheByCardItem(formItem, isOuter);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
  }

  public setFormUninstallState(state: boolean): void {
    this.mFormComponentVm.mFormInUninstall = state;
  }

  public setFormVisibility(visibility: boolean): void {
    log.showInfo(`${this.mFormItem.cardId} setFormVisibility, visibility: ${visibility}`);
    this.mFormComponentVm.mFormVisible = visibility;
  }

  public setFormOpacity(opacity: number): void {
    log.showInfo(`${this.mFormItem.cardId} setFormOpacity, opacity: ${opacity}`);
    this.mFormComponentVm.mFormOpacity = opacity;
  }

  public getFormVisibility(): boolean {
    log.showInfo(`getFormVisibility ${this.mFormItem.cardId}, visibility: ${this.mFormComponentVm.mFormVisible}`);
    return this.mFormComponentVm.mFormVisible;
  }

  public getFormOpacity(): number {
    log.showInfo(`${this.mFormItem.cardId} getFormOpacity, opacity: ${this.mFormComponentVm.mFormOpacity}`);
    return this.mFormComponentVm.mFormOpacity;
  }

  public isFormSupportShadow(): boolean {
    let disableShadow: boolean = FormComponentModel.getInstance().getDisableShadow();
    return !disableShadow && (DeviceHelper.isBarPhone()) &&
      !this.mFormItem.isTransparent && !this.mFormComponentVm.mFormInUninstall;
  }

  private onEventhubEvent(isShowIcon: boolean): void {
    this.mFormComponentVm.mFormOpacity = (isShowIcon ? CommonConstants.OPACITY_ONE : CommonConstants.OPACITY_ZERO);
  }

  public initFsExpandStatusEventhub(cardId: string): void {
    this.mFormComponentVm.mFormVisible = false;
    let eventId: string = `formStackClosed${cardId}`;
    this.desktopContext?.eventHub.on(eventId, this.onEventhubFsClosedEventHandler);
  }

  private onEventhubFsClosedEvent(cardId: string): void {
    this.mFormComponentVm.mFormVisible = true;
    let eventId: string = `formStackClosed${cardId}`;
    log.showInfo(`formstack close done, eventId: ${eventId}`);
    this.desktopContext?.eventHub.off(eventId, this.onEventhubFsClosedEventHandler);
    AppStorage.set('cardDropByFromStackExpandClose', 0);
  }

  private generateCardQuintuple(info: CardItemInfo): string {
    return `${info.bundleName}_${info.moduleName}_${info.abilityName}_${info.cardName}_${info.cardDimension}`;
  }
}