/**
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

import { BaseStage, DeviceHelper } from '@ohos/frameworkwrapper';
import { layoutConfigManager } from '@ohos/launchercommon';
import { bigFolderPreLoader, OpenFolderAppBubbleNodeManager } from '@ohos/bigfolder';
import { formPreLoader } from '@ohos/form';
import { pageDesktopPreLoader } from '@ohos/pagedesktop';
import { smartDockPreLoader } from '@ohos/smartdock';
import { NumBadgeManager } from '@ohos/numbadge';
import PhoneSmartDockLayoutConfig from './PhoneSmartDockLayoutConfig';
import PhonePageDesktopGridStyleConfig from './PhonePageDesktopGridStyleConfig';
import PhoneFolderLayoutConfig from './folder/PhoneFolderLayoutConfig';
import launcherLayoutPreLoader from './LauncherLayoutPreLoader';
import PhoneFormLayoutConfig from './PhoneFormLayoutConfig';
import PhonePageDesktopLayoutConfig from './PhonePageDesktopLayoutConfig';
import lazy OuterPhonePageDesktopLayoutConfig from './OuterPhonePageDesktopLayoutConfig';
import { LauncherStartup, StartupStep } from '@ohos/launchercommon/src/main/ets/tools/LauncherStartup';

/**
 * phone product stage
 */
export default class PhoneStage extends BaseStage {
  /**
   * Stage onCreate callback
   */
  onCreate(): void {
    super.onCreate();
    OpenFolderAppBubbleNodeManager.getInstance();
    this.initPhoneConfig();
    launcherLayoutPreLoader.load();
    smartDockPreLoader.load();
    pageDesktopPreLoader.load();
    layoutConfigManager.addConfigToManager(PhonePageDesktopGridStyleConfig.getInstance());
    bigFolderPreLoader.load();
    formPreLoader.load();
    NumBadgeManager.getInstance().registerNumBadge();
    LauncherStartup.getInstance().passStep(StartupStep.PHONE_STAGE);
  }

  /**
   * init phone layout config
   */
  private initPhoneConfig(): void {
    layoutConfigManager.addConfigToManager(PhoneSmartDockLayoutConfig.getInstance());
    layoutConfigManager.addConfigToManager(PhoneFolderLayoutConfig.getInstance());
    layoutConfigManager.addConfigToManager(PhoneFormLayoutConfig.getInstance());
    layoutConfigManager.addConfigToManager(PhonePageDesktopLayoutConfig.getInstance());
  }

  /**
   * Stage onDestroy callback
   */
  onDestroy(): void {
    super.onDestroy();
    smartDockPreLoader.releaseConfigAndData();
    pageDesktopPreLoader.releaseConfigAndData();
    bigFolderPreLoader.releaseConfigAndData();
    formPreLoader.releaseConfigAndData();
    launcherLayoutPreLoader.releaseConfigAndData();
    NumBadgeManager.getInstance().unRegisterNumBadge();
  }
}
