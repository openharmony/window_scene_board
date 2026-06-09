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
import { SystemSceneBuilderParam, AbstractSCBSceneRegisterManager } from '@ohos/windowscene/Index';
import { SCBWallpaper } from '../systemscene/SCBWallpaper';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { SCBVolumePanel } from '@ohos/default_volumepanel/src/main/ets/pages/SCBVolumePanel';
import { SCBDropdownBuilder } from '../dropdownpanel/SCBDropdownBuilder';
import { SCBDesktop } from '../systemscene/SCBDesktop';
import { SCBBannerBuilder } from '../bannerpanel/SCBBannerBuilder';
import { SCBGestureTopBar } from '../statusbar/SCBGestureTopBar';
import { SCBStatusBarBuilder } from '../statusbar/SCBStatusBarBuilder';
import { SCBGestureBack } from '../systemscene/SCBGestureBack';
import { SCBGestureNavBar } from '../systemscene/SCBGestureNavBar';
import { SCBGestureDock } from '../gestureDock/SCBGestureDock';
import { SCBSysDialogDefault, SCBSysDialogUpper } from '@ohos/systemdialog/src/main/ets/pages/SCBSysDialog';
import lazy { CFWKSysDialogDefault, CFWKSysDialogUpper } from '@ohos/collaborationfwkdialog/src/main/ets/pages/CFWKSysDialog';
import { SCBScreenLock } from '../screenlock/SCBScreenLock';
import { SCBFormCenter } from '../formcenter/view/SCBFormCenter';
import lazy { SmartDockPcMode } from '../systemscene/SmartDockPcMode';
import { SCBBrightnessPanel } from '../brightnesspanel/pages/SCBBrightnessPanel';
import lazy { SCBScreenMattesPanel } from '@ohos/foldeffect/src/main/ets/pages/SCBScreenMattesPanel';
import lazy { OneHandModeBackground } from './onehandmode/OneHandModeBackground';
import lazy { SCBSingleHandController } from './onehandmode/SCBSingleHandController';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = 'SCBSceneRegisterManager';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

@Builder function volumePanelBuilder($$: SystemSceneBuilderParam) {
  SCBVolumePanel({persistentId: $$.persistentId})
}

@Builder function dropDownBuilder($$: SystemSceneBuilderParam) {
  SCBDropdownBuilder({ persistentId: $$.persistentId, screenProp: $$.screenProp })
}

@Builder function wallpaperBuilder($$: SystemSceneBuilderParam) {
  SCBWallpaper({ persistentId: $$.persistentId, screenProp: $$.screenProp })
}

@Builder function desktopBuilder($$: SystemSceneBuilderParam) {
  SCBDesktop({persistentId: $$.persistentId, screenProp: $$.screenProp})
}

@Builder function bannerBuilder($$: SystemSceneBuilderParam) {
  SCBBannerBuilder({ persistentId: $$.persistentId, screenProp: $$.screenProp })
}

@Builder function gestureTopBarBuilder($$: SystemSceneBuilderParam) {
  SCBGestureTopBar({persistentId: $$.persistentId, screenProp: $$.screenProp})
}

@Builder function statusBarBuilder($$: SystemSceneBuilderParam) {
  SCBStatusBarBuilder({persistentId: $$.persistentId, screenProp: $$.screenProp})
    .id('StatusBarBox')
}

@Builder function gestureBackBuilder($$: SystemSceneBuilderParam) {
  SCBGestureBack({persistentId: $$.persistentId, screenProperty: $$.screenProp })
}

@Builder function gestureNavigationBuilder($$: SystemSceneBuilderParam) {
  SCBGestureNavBar({persistentId: $$.persistentId, screenProperty: $$.screenProp })
}

@Builder function gestureDockBuilder($$: SystemSceneBuilderParam) {
  SCBGestureDock({persistentId: $$.persistentId, screenProperty: $$.screenProp })
}

@Builder function sysDialogDefaultBuilder($$: SystemSceneBuilderParam) {
  SCBSysDialogDefault({ persistentId: $$.persistentId, screenProp: $$.screenProp })
}

@Builder function cfwkDialogDefaultBuilder($$: SystemSceneBuilderParam) {
  CFWKSysDialogDefault({ persistentId: $$.persistentId, screenProp: $$.screenProp })
}

@Builder function sysDialogUpperBuilder($$: SystemSceneBuilderParam) {
  SCBSysDialogUpper({ persistentId: $$.persistentId, screenProp: $$.screenProp })
}

@Builder function cfwkDialogUpperBuilder($$: SystemSceneBuilderParam) {
  CFWKSysDialogUpper({ persistentId: $$.persistentId, screenProp: $$.screenProp })
}

@Builder function screenLockBuilder($$: SystemSceneBuilderParam) {
  SCBScreenLock({persistentId: $$.persistentId, screenProp: $$.screenProp})
}

@Builder function formCenterBuilder($$: SystemSceneBuilderParam) {
  SCBFormCenter({persistentId: $$.persistentId, screenProp: $$.screenProp});
}

@Builder function pcSmartDockBuilder($$: SystemSceneBuilderParam) {
  SmartDockPcMode({ persistentId: $$.persistentId, screenProp: $$.screenProp })
}

@Builder function brightnessPanelBuilder($$: SystemSceneBuilderParam) {
  SCBBrightnessPanel({ persistentId: $$.persistentId })
}

@Builder function screenMattesPanelBuilder($$: SystemSceneBuilderParam) {
  if (DeviceHelper.isLargeInFoldProduct()) {
    SCBScreenMattesPanel({ persistentId: $$.persistentId, screenProp: $$.screenProp })
  }
}

@Builder function oneHandModeBackgroundBuilder($$: SystemSceneBuilderParam) {
  OneHandModeBackground({screenProp: $$.screenProp});
}

export class SCBSceneRegisterManager extends AbstractSCBSceneRegisterManager {
  private static instances: SCBSceneRegisterManager;

  static getInstance(): SCBSceneRegisterManager {
    if (!SCBSceneRegisterManager.instances) {
      SCBSceneRegisterManager.instances = new SCBSceneRegisterManager();
    }
    return SCBSceneRegisterManager.instances;
  }

  public registerSystemSceneBuilder(): void {
    log.info('registerSystemSceneBuilder');
    this.systemSceneBuilderMap.set('SCBWallpaper', wallpaperBuilder);
    this.systemSceneBuilderMap.set('SCBDesktop', desktopBuilder);
    this.systemSceneBuilderMap.set('SCBBannerNotification', bannerBuilder);
    this.systemSceneBuilderMap.set('SCBGestureTopBar', gestureTopBarBuilder);
    this.systemSceneBuilderMap.set('SCBSysDialogDefault', sysDialogDefaultBuilder);
    this.systemSceneBuilderMap.set('SCBScreenLock', screenLockBuilder);
    this.systemSceneBuilderMap.set('SCBGestureDock', gestureDockBuilder);
    this.systemSceneBuilderMap.set('SCBGestureNavBar', gestureNavigationBuilder);
    this.systemSceneBuilderMap.set('SCBStatusBar', statusBarBuilder);
    this.systemSceneBuilderMap.set('SCBDropdownPanel', dropDownBuilder);
    this.systemSceneBuilderMap.set('SCBSysDialogUpper', sysDialogUpperBuilder);
    this.systemSceneBuilderMap.set('SCBVolumePanel', volumePanelBuilder);
    this.systemSceneBuilderMap.set('SCBGestureBack', gestureBackBuilder);
    this.systemSceneBuilderMap.set('SCBFormCenter', formCenterBuilder);
    this.systemSceneBuilderMap.set('SmartDockPcMode', pcSmartDockBuilder);
    this.systemSceneBuilderMap.set('SCBbrightnessPanel', brightnessPanelBuilder);
    this.systemSceneBuilderMap.set('OneHandModeBackground', oneHandModeBackgroundBuilder);
    if (DeviceHelper.isLargeInFoldProduct()) {
      this.systemSceneBuilderMap.set('SCBScreenMattesPanel', screenMattesPanelBuilder);
    }
    this.systemSceneBuilderMap.set('CFWKSysDialogDefault', cfwkDialogDefaultBuilder);
    this.systemSceneBuilderMap.set('CFWKSysDialogUpper', cfwkDialogUpperBuilder);
  }
}