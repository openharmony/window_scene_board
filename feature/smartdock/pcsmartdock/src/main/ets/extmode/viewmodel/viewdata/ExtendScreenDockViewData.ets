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
import { DockItemInfo } from '@ohos/launchercommon';

@Observed
export class ExtendScreenDockViewData {
  public isResidentArrowShow: boolean = false;
  public isRecentArrowShow: boolean = false;
  public isShowContinuableItem: boolean = false;
  public localResidentList: DockItemInfo[] = [];
  public localRecentList: DockItemInfo[] = [];
  public currColorMode: number = 0;
  public screenId: number = 0;
  public residentListAreaWidth: number = 0;
  public recentListAreaWidth: number = 0;
  public threshold: number = 0;
  public residentNum: number = 0;
  public recentNum: number = 0;
  public residentMaxMaxNum: number = 0;
  public recentMaxMaxNum: number = 0;
  public additionResidentListWidth: number = 0;
  public additionRecentListWidth: number = 0;
  public baseResidentListWidth: number = 0;
  public baseRecentListWidth: number = 0;
  public systemItemList: DockItemInfo[] = [];
}