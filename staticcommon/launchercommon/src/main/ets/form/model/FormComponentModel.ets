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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBVisualEffectMgr } from '@ohos/componenthelper';
import { VisualEffectConstants } from '@ohos/commonconstants';
import { CardItemInfo, GridLayoutItemInfo } from '../../TsIndex';
import { FormComponentEvent } from '../viewmodel/FormComponentEvent';

const TAG = 'FormComponentModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormComponentModel {
  private static mInstance: FormComponentModel;
  private mViewData: Map<string, FormComponentEvent[]> = new Map();
  private disableShadow: boolean = false;
  private isInScreenRotateAni_: boolean = false;

  constructor() {
    this.disableShadow = SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.ICON_CARD_SHADOW_DISABLE);
  }

  static getInstance(): FormComponentModel {
    if (CheckEmptyUtils.isEmpty(FormComponentModel.mInstance)) {
      FormComponentModel.mInstance = new FormComponentModel();
    }
    return FormComponentModel.mInstance;
  }

  public isInScreenRotateAni(): boolean {
    return this.isInScreenRotateAni_;
  }

  public setIsScreenRotateAni(isInScreenRotateAni: boolean): void {
    this.isInScreenRotateAni_ = isInScreenRotateAni;
  }

  public registerViewData(formInfo: CardItemInfo, viewData: FormComponentEvent): void {
    log.showInfo(`registerViewData ${formInfo.cardId}`);
    let keyString: string = `${formInfo.cardId}`;
    let viewDataList: FormComponentEvent[] = [];
    if (this.mViewData.has(keyString)) {
      viewDataList = this.mViewData.get(keyString) as FormComponentEvent[];
      if (viewDataList.find((item) => item === viewData)) {
        log.showInfo(`${keyString} register repeat`);
        return;
      }
    }
    viewDataList.push(viewData);
    this.mViewData.set(keyString, viewDataList);
  }

  public unRegisterViewData(formInfo: CardItemInfo, viewData: FormComponentEvent): void {
    let keyString: string = `${formInfo.cardId}`;
    log.showInfo(`unregisterViewData ${formInfo.cardId}`);
    if (!this.mViewData.has(keyString)) {
      log.showInfo(`${formInfo.cardId} viewData empty`);
      return;
    }
    let viewDataList: FormComponentEvent[] = this.mViewData.get(keyString) as FormComponentEvent[];
    if (viewDataList.length > 1) {
      viewDataList.forEach((value, index) => {
        if (value === viewData) {
          viewDataList.splice(index, 1);
          this.mViewData.set(keyString, viewDataList);
        }
      })
    } else {
      log.showInfo(`no more ${keyString}, delete all`);
      this.mViewData.delete(keyString);
    }
  }

  public hideForm(layoutInfo: GridLayoutItemInfo): void {
    log.showInfo(`hide form ${layoutInfo.cardId}`);
    let keyString: string = `${layoutInfo.cardId}`;
    if (!this.mViewData.has(keyString)) {
      log.showInfo('hideForm: no such form');
      return;
    }
    let viewDataList: FormComponentEvent[] = this.mViewData.get(keyString) as FormComponentEvent[];
    viewDataList.forEach((info) => {
      info.setFormVisibility(false);
    });
  }

  public showForm(layoutInfo: GridLayoutItemInfo): void {
    log.showInfo(`show form ${layoutInfo.cardId}`);
    let keyString: string = `${layoutInfo.cardId}`;
    if (!this.mViewData.has(keyString)) {
      log.showInfo('showForm: no such form');
      return;
    }
    let viewDataList: FormComponentEvent[] = this.mViewData.get(keyString) as FormComponentEvent[];
    viewDataList.forEach((info) => {
      info.setFormVisibility(true);
    });
  }

  public setFormOpacity(layoutInfo: GridLayoutItemInfo, opacity: number): void {
    log.showInfo(`setFormOpacity form ${layoutInfo.cardId}, opacity: ${opacity}`);
    let keyString: string = `${layoutInfo.cardId}`;
    if (!this.mViewData.has(keyString)) {
      log.showInfo(`setFormOpacity: no such form,current formlist: ${Array.from(this.mViewData.keys()).toString()}`);
      return;
    }
    let viewDataList: FormComponentEvent[] = this.mViewData.get(keyString) as FormComponentEvent[];
    viewDataList.forEach((info) => {
      info.setFormOpacity(opacity);
    });
  }

  public getDisableShadow(): boolean {
    return this.disableShadow;
  }

  /**
   * 获取组件大小
   *
   * @param formItemWidth 卡片宽度
   * @param formItemHeight 卡片高度
   * @param isOuterDesktop 是否是verde外屏
   * @returns 对应组件大小
   */
  public getComponentSize(formItemWidth: number, formItemHeight: number, isOuterDesktop: boolean): SizeOptions {
    if (isOuterDesktop) {
      return { width: formItemWidth, height: formItemHeight };
    }
    return { width: '100%', height: '100%' };
  }
}