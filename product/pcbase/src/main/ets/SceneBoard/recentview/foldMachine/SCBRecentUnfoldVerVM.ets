/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { SCBRecentPanelManager } from '../SCBRecentPanelViewModel';
import { AnimationType, CustomAnimateParam, SCBRecentFoldMachineVM } from './SCBRecentFoldMachineVM';
import { SCBRecentStyle, SCBRecentStyleManager } from './SCBRecentStyle';

const TAG = 'Recent-SCBRecentUnfoldVerVM';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

/**
 * 大屏幕机竖向展开态
 */
export class SCBRecentUnfoldVerVM extends SCBRecentFoldMachineVM {

  private foldAnimateParam: CustomAnimateParam = { duration: 300, curve: Curve.Friction, needUpdateStack: true };

  protected static instance: SCBRecentUnfoldVerVM;

  public static getInstance(): SCBRecentUnfoldVerVM {
    if (!SCBRecentUnfoldVerVM.instance) {
      SCBRecentUnfoldVerVM.instance = new SCBRecentUnfoldVerVM();
    }
		return SCBRecentUnfoldVerVM.instance;
	}

  runAnimation(key: AnimationType, screenID: number, param?: CustomAnimateParam | undefined): void {
    super.executeAnimation(key, screenID, param);
  }
}