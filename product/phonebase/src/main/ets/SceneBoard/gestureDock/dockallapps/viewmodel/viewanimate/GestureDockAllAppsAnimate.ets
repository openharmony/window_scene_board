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
import { AllAppsParam } from '../viewdata/GestureDockAllAppsParam';
import GestureDockAllAppsViewDataMgr from '../viewdata/GestureDockAllAppsViewDataMgr';

const TAG = 'GestureDockBarViewAnimate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

export default class GestureDockAllAppsViewAnimate {
  private viewDataMgr: GestureDockAllAppsViewDataMgr;
  private allAppsParam: AllAppsParam;

  constructor(viewDataMgr: GestureDockAllAppsViewDataMgr) {
    this.viewDataMgr = viewDataMgr;
    this.allAppsParam = this.viewDataMgr.allAppsParam;
  }
}