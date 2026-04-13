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

import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';
import { ResourceManager } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager, SessionLabelListener } from '@ohos/windowscene';
import { AppItemInfo, SnapshotInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FixedDockResource } from '../common/constants/FixedDockConstants';

const TAG = 'PreviewImageLabelName';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);


@Component
export struct PreviewImageLabelName {
  private snapShotItem: SnapshotInfo = new SnapshotInfo();
  @Link customWidth: number;
  private customHeight: number = 0;
  private labelName: string = '';

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear ${this.snapShotItem.bundleName}, ${this.snapShotItem.missionId}`);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear ${this.snapShotItem.bundleName}, ${this.snapShotItem.missionId}`);
  }

  build() {
    Row() {
      Text(this.labelName)
        .draggable(false)
        .width(this.customWidth)
        .height(this.customHeight)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontSize($r('sys.float.Subtitle_M'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .textAlign(TextAlign.Start)
        .maxLines(1)
        .hoverEffect(HoverEffect.None)
        .fontWeight(FontWeight.Medium)
    }
    .padding({ top: FixedDockResource.TIPS_TEXT_PADDING })
  }
}