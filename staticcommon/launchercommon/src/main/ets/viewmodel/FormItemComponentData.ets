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
import { CardItemInfo, GridLayoutItemInfo } from '../TsIndex';

const TAG = 'FormItemComponentData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Observed
export class FormItemComponentData {
  public mIsFormShow: boolean = true;
}

export class FormItemComponentModel {
  private static mInstance: FormItemComponentModel;
  private mViewData: Map<string, FormItemComponentData[]> = new Map();

  constructor() {
  }

  static getInstance(): FormItemComponentModel {
    if (CheckEmptyUtils.isEmpty(FormItemComponentModel.mInstance)) {
      FormItemComponentModel.mInstance = new FormItemComponentModel();
    }
    return FormItemComponentModel.mInstance;
  }

  public registerViewData(formInfo: CardItemInfo, viewData: FormItemComponentData): void {
    log.showInfo(`registerViewData ${formInfo.cardId}`);
    let keyString: string = `${formInfo.cardId}`;
    let viewDataList: FormItemComponentData[] = [];
    if (this.mViewData.has(keyString)) {
      viewDataList = this.mViewData.get(keyString) as FormItemComponentData[];
      if (viewDataList.find((item) => item === viewData)) {
        log.showInfo(`${keyString} register repeat`);
        return;
      }
    }
    viewDataList.push(viewData);
    this.mViewData.set(keyString, viewDataList);
  }

  public unregisterViewData(formInfo: CardItemInfo, viewData: FormItemComponentData): void {
    let keyString: string = `${formInfo.cardId}`;
    log.showInfo(`unregisterViewData ${formInfo.cardId}`);
    if (!this.mViewData.has(keyString)) {
      log.showInfo(`${formInfo.cardId} viewData empty`);
      return;
    }
    let viewDataList: FormItemComponentData[] = this.mViewData.get(keyString) as FormItemComponentData[];
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
    let viewDataList: FormItemComponentData[] = this.mViewData.get(keyString) as FormItemComponentData[];
    viewDataList.forEach((info) => {
      info.mIsFormShow = false;
    });
  }

  public showForm(layoutInfo: GridLayoutItemInfo): void {
    log.showInfo(`show form ${layoutInfo.cardId}`);
    let keyString: string = `${layoutInfo.cardId}`;
    if (!this.mViewData.has(keyString)) {
      log.showInfo('showForm: no such form');
      return;
    }
    let viewDataList: FormItemComponentData[] = this.mViewData.get(keyString) as FormItemComponentData[];
    viewDataList.forEach((info) => {
      info.mIsFormShow = true;
    });
  }
}