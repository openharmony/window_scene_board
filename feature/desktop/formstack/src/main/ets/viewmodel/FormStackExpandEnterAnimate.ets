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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { FormStackUtil } from '../common/FormStackUtil';
import { FormStackExpandViewData } from './FormStackExpandViewData';
import { FormStackExpandLayoutAnimate } from './FormStackExpandLayoutAnimate';

const TAG: string = 'FormStackExpandEnterAnimate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormStackExpandEnterAnimate {
  private mViewData?: FormStackExpandViewData;
  private mLayoutAnimate?: FormStackExpandLayoutAnimate;

  public initData(viewData: FormStackExpandViewData, layoutAnimate: FormStackExpandLayoutAnimate): void {
    this.mViewData = viewData;
    this.mLayoutAnimate = layoutAnimate;
  }

  public resetData(): void {
    this.mViewData = undefined;
    this.mLayoutAnimate = undefined;
  }

  public enterFormStackExpand(): void {
    if (!this.mViewData || FormStackUtil.isInvalidFormStackList(this.mViewData.mItemInfoList)) {
      log.showError(`enter form stack animate play failed, item list len: ${this.mViewData?.mItemInfoList?.length}!`);
      return;
    }

    log.showInfo('start playing animate: enter form stack expand.');
    this.mLayoutAnimate?.layoutFormStackExpand();
  }
}