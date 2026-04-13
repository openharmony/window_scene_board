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

import curves from '@ohos.curves';
import { ResUtils } from '@ohos/windowscene';

export class FormItemRelativeVm {
  // 组件移除缩小动效
  @Track public mAnimateScale: number = 1.0;
  // 组件移除动效透明度 & 折叠开合滑入动效透明度
  @Track public mAnimateOpacity: number = 1.0;
  // 组件移除背景模糊
  @Track public mAnimateBlur: number = 0;

  @Track public mFormBorderRadius: number = ResUtils.getNumber($r('app.float.form_corner_radius'));
  @Track public mDropAnimateScale: number = 1;
  @Track public mDropAnimateTranslateY: number = 0;

  @Track public mIsDragItem: boolean = false;
  @Track public mIsInFormHotArea: boolean = false;

  @Track public isOverflowFormEnable: boolean = false;
  @Track public isFormEnabled: boolean = true;
  @Track public formVisibilityStatus: Visibility = Visibility.Visible;
  // 卡片是否支持调整大小
  @Track public supportZoom: boolean = false;
}

export class FormAnimateData {
  public cardId: string = '';
  public isOpenRemoveFormDialog: boolean = false;
}

export const enum CardArea {
  SMALL,
  MIDDLE,
  LARGE
};

export interface CardAnimParams {
  curve: curves.ICurve;
  scale: number;
};

export class FormBackboardVm {
  @Track public mFormBackboardScale: number = 1;
  @Track public mFormBackboardRadius: number = 0;
  @Track public mSizeRatio: number = 0;
  // 形成堆叠时，堆叠背板显隐控制
  @Track public mIsFormBackOpen: boolean = false;
}

export class FormMaskVm {
  @Track public mFormMaskOpacity: number = 0;
}