/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ResourceManager } from '@ohos/frameworkwrapper';
import { SCBRecentStyleConstants } from './SCBRecentStyleConstants';
import type { SessionLabelListener } from '@ohos/windowscene';
import { SCBSceneSessionManager, SCBSceneResourceManager } from '@ohos/windowscene';
import { SCBRecentTitleViewModel } from './SCBRecentTitleViewModel';

const TAG = 'SCBRecentTitleAppName';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

/**
 * App name component for recent sessions.
 */
@Component
export default struct SCBRecentTitleAppName {
  @Prop @Watch('updateName') appName: string = '';
  @State name: string = ''
  @Prop @Watch('updateName') bundleName: string = '';
  @Prop @Watch('updateName') moduleName: string = '';
  @Prop @Watch('updateName') labelId: number = 0;
  @Prop @Watch('updateName') appIndex: number = 0;
  @Prop @Watch('updateName') persistentId: number = 0;
  private mResourceManager: ResourceManager = ResourceManager.getInstance();


  private sessionLabelListener: SessionLabelListener = {
    onUpdate: (label: string) => {
      this.name = label;
    }
  }

  /**
   * The callback of recent sessions app name.
   *
   * @param {string} name - the value get from ResourceManager
   */
  private appNameLoadCallback(name: string): void {
    if (CheckEmptyUtils.isEmpty(name)) {
      return;
    }
    log.showInfo(`update app title name of ${this.bundleName}-${this.moduleName} to ${name} successfully`);
    this.name = name;
  }

  /**
   * Update the app name of recent sessions.
   */
  private async updateName(): Promise<void> {
    const sessionLabel: string = SCBSceneResourceManager.getInstance().getSessionLabelCache(this.persistentId);
    if (sessionLabel) {
      log.showInfo(`start update app title name of persistendtId, ${sessionLabel}-${this.persistentId}`);
      this.name = sessionLabel;
      return;
    }
    if (CheckEmptyUtils.isEmpty(this.appName) && this.bundleName && this.bundleName.length > 0 &&
    this.mResourceManager) {
      log.showInfo(`start update app title name of ${this.bundleName}-${this.moduleName} from cache`);
      this.mResourceManager.getAppNameWithCache(this.labelId,
        this.bundleName, this.moduleName, this.appName,
        (name: string): void => this.appNameLoadCallback(name), this.appIndex);
    }
    log.showInfo(`start update app title name of ${this.bundleName}-${this.moduleName}`);
    this.appNameLoadCallback(this.appName);
  }

  @Styles
  normalStyles() {
    .border({
      width: 0,
      color: '#00000000',
    })
  }

  aboutToAppear(): void {
    this.updateName();
    SCBSceneSessionManager.getInstance().registerSessionLabelListener(this.persistentId, this.sessionLabelListener);
  }

  aboutToDisappear(): void {
    SCBSceneSessionManager.getInstance().unRegisterSessionLabelListener(this.persistentId, this.sessionLabelListener);
  }

  build() {
    Column() {
      Text(this.name)
        .draggable(false)
        .fontSize(SCBRecentStyleConstants.DEFAULT_APP_NAME_SIZE)
        .fontColor(SCBRecentStyleConstants.DEFAULT_FONT_COLOR)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .id(SCBRecentTitleViewModel.getRecentTitleAppNameId(this.persistentId, this.bundleName))
        .maxLines(SCBRecentStyleConstants.DEFAULT_NAME_LINE)
        .focusable(true)
        .tabIndex(-1)
        .stateStyles({
          normal: this.normalStyles,
          focused: this.normalStyles
        })
    }
  }
}