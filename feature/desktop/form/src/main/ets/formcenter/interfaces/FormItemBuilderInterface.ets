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

import Want from '@ohos.app.ability.Want';
import { CardItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FormDescriptionStyle } from '../viewstyles/FormDescriptionStyle';

// 卡片信息
export interface FormUIConfig {
  // 卡片信息
  formItem: CardItemInfo;

  // 创建卡片的want信息
  want?: Want;

  // 卡片实际展示宽度
  formDisplayWidth?: number;

  // 卡片实际展示高度
  formDisplayHeight?: number;

  // 卡片宽度
  formWidth?: number;

  // 卡片高度
  formHeight?: number;

  // 卡片圆角半径
  formRadius?: number;

  // 卡片缩放比例
  formScale?: number;

  // 卡片id
  cardId: string;

  // 卡片数据在数组中的索引
  index: number;

  // 卡片透明度
  formOpacity: number;

  // 布局类型 NavDestinationLayout 枚举值
  layoutType: number;

  // 是否支持提亮操作
  isSupportBrightness?: boolean;

  // 内描边
  isNeedFormInnerLine?: boolean;

  // 卡片渐显动效
  hasFadeInAnimation?: boolean;
}

// 卡片事件处理
export interface FormEventCallback {
  // 卡片创建请求回调
  onAcquired?: (cardId: string) => void;

  // 卡片加载回调
  onLoad?: () => void;

  // 卡片创建异常回调
  onError?: (errorMsg: string) => void;
}

// 卡片名称信息
export interface FormNameParam {
  // 卡片信息
  formItem: CardItemInfo;

  // 卡片名称样式
  style?: FormDescriptionStyle;

  // 卡片数据在数组中的索引
  index: number;
}

// 创建的卡片信息
export interface FormItemParam {
  // 卡片信息
  formUIConfig: FormUIConfig;

  // 卡片事件处理
  event: FormEventCallback;
}

// 创建的卡片内描边信息
export interface FormInLineBorderParam {
  // 卡片圆角半径
  borderRadius: number;
}

export interface FormItemBuilderInterface {
  // 创建卡片
  buildView: () => WrappedBuilder<FormItemParam[]>;
}