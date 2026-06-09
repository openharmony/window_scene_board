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
import { DockItemInfo, StyleConstants } from '@ohos/launchercommon';

@Observed
export class DockArrowViewData {
  public screenId: number = 0;
  public scrollAnimDuration: number = 600;
  public leftArrowPath: ResourceStr = $r('sys.media.ohos_ic_public_arrow_left');
  public rightArrowPath: ResourceStr = $r('sys.media.ohos_ic_public_arrow_right');
  public residentLeftArrowOpacity: Resource | number = 1;
  public residentRightArrowOpacity: Resource | number = 1;
  public recentLeftArrowOpacity: Resource | number = 1;
  public recentRightArrowOpacity: Resource | number = 1;
  public residentLeftArrowBgColor: ResourceColor | null = null;
  public residentRightArrowBgColor: ResourceColor | null = null;
  public recentLeftArrowBgColor: Resource | null = null;
  public recentRightArrowBgColor: Resource | null = null;
  public isResidentLeftArrowClickable: boolean = true;
  public isResidentRightArrowClickable: boolean = true;
  public isRecentLeftArrowClickable: boolean = true;
  public isRecentRightArrowClickable: boolean = true;
  public isResidentLeftArrowHover: boolean = false;
  public isResidentRightArrowHover: boolean = false;
  public isRecentLeftArrowHover: boolean = false;
  public isRecentRightArrowHover: boolean = false;
  public residentStartIndex: number = 0;
  public recentStartIndex: number = 0;
  public localResidentList: DockItemInfo[] = [];
  public localRecentList: DockItemInfo[] = [];
  public residentMaxMaxNum: number = 0;
  public recentMaxMaxNum: number = 0;
  public threshold: number = 0;
  public residentNum: number = 0;
  public recentNum: number = 0;
  public isResidentArrowShow: boolean = false;
  public isRecentArrowShow: boolean = false;
}