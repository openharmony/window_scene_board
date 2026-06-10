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
import { StyleConstants } from '@ohos/launchercommon';


export class DockArrowModel {
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
  public isResidentArrowShow: boolean = false;
  public isRecentArrowShow: boolean = false;

  /**
   * output as a string
   *
   * @returns
   */
  public toString(): string {
    return [`rsdt-l-click: ${this.isResidentLeftArrowClickable}`,
      `rsdt-r-click: ${this.isResidentRightArrowClickable}`, `rct-l-click: ${this.isRecentLeftArrowClickable}`,
      `rct-r-click: ${this.isRecentRightArrowClickable}`, `rsdt-l-h: ${this.isResidentLeftArrowHover}`,
      `rsdt-r-h: ${this.isResidentRightArrowHover}`, `rct-l-h:${this.isRecentLeftArrowHover}`,
      `rct-r-h:${this.isRecentRightArrowHover}`, `rsdt-a-show:${this.isResidentArrowShow}`,
      `rct-a-show:${this.isRecentArrowShow}`].join(',');
  }
}