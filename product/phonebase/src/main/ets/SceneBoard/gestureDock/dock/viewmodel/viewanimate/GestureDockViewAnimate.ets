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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GestureDockViewParam } from '../viewdata/GestureDockParam';
import GestureDockViewDataMgr from '../viewdata/GestureDockViewDataMgr';
import { GestureDockBarViewModel } from '../../../dockbar/viewmodel/GestureDockBarViewModel';

const TAG = 'GestureDockBarViewAnimate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * GestureDock动效
 */
export default class GestureDockViewAnimate {
  private viewDataMgr: GestureDockViewDataMgr;
  private gestureDockParam: GestureDockViewParam;
  private dockBarViewModel: GestureDockBarViewModel = GestureDockBarViewModel.getInstance();

  /**
   * 构造函数
   *
   * @param viewDataMgr viewDataMgr
   */
  public constructor(viewDataMgr: GestureDockViewDataMgr) {
    this.viewDataMgr = viewDataMgr;
    this.gestureDockParam = this.viewDataMgr.gestureDockParam;
  }

}