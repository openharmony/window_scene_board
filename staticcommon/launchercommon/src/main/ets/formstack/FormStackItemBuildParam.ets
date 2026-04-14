/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { FormStackItemEventCb } from './FormStackItemEventCb';
import { FormStackItemViewData } from './FormStackItemViewData';

export interface CommonConfigData {
  mLayout: GridLayoutItemInfo;
  mFixedOffsetY: number;
  mShadowStyle: ShadowOptions;
  mCompId: string;
  mIsOuterDesktop: boolean;
  cardDimension: number;
}

export interface FormStackItemBuildParam {
  // 基础配置信息
  mConfigData: CommonConfigData;

  // 事件回调接口
  mEventCb: FormStackItemEventCb;

  // 状态变量
  mViewData: FormStackItemViewData;
}