/*
 * Copyright (c) 2023-2025 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { ThreadUtil } from '@ohos/basicutils/src/main/ets/utils/ThreadUtil';
import { CardMediaController } from '../Controller/CardMediaController';
import { CardMediaControllerDc } from '../Controller/CardMediaControllerDc';
import { DcMediaController } from '../Controller/DcMediaController';
import { ListDialog } from './components/ListDialog';
import Constants from '../Util/Constants';
import deviceInfo from '@ohos.deviceInfo';
import screenLock from '@ohos.screenLock';
import { HiSysEvent } from '../Util/HiSysEvent';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { CurrentMemScene, PerformanceReporter } from '@ohos/frameworkcommon/src/main/ets/memory/PerformanceReporter';
import { systemUIWorkerManager } from '@ohos/systemuicommon/src/main/ets/manager/SystemUIWorkerManager';
import { ResourceVm } from '@ohos/systemuicommon/src/main/ets/vm/ResourceVm';
import { MediaViewModelManager, MediaVMType } from '../viewmodel/MediaViewModelManager';
import { SysConfigData } from '../viewmodel/SysConfigData';
import { DropDownAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/DropDownAdapter';

const TAG: string = 'MediaPlaybackComponent_debug';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

interface pageParameters {
  message?: string;
}

/**
 * 播控中心二级页面
 */
@Component
export default struct MediaPlaybackComponent {
  /**
   * 是否开启worker子线程
   */
  private enableDc: boolean = systemUIWorkerManager.isEnabled();
  @State parameters: pageParameters = this.enableDc ? (DcMediaController.showingWant?.parameters || {}) :
    (CardMediaController.showingWant?.parameters || {});
  @StorageProp('fontSizeScale') fontSizeScale: number = 1;
  @State showDeviceList: boolean = this.parameters.message === 'switch'; // 是否显示设备列表
  @State isShowDeviceAnim: boolean = this.parameters.message === 'switch'; // 是否显示设备列表
  @State deviceType: string = deviceInfo.deviceType;
  @State isLocked: boolean = screenLock.isLocked();
  @State showAnimateDone: boolean = false; // 初始化动效是否执行完毕
  private controller: CardMediaController | CardMediaControllerDc = this.enableDc ?
    CardMediaControllerDc.getInstance() : CardMediaController.getInstance(); // 开启worker时，使用DC子线程controller
  @State switchMode: boolean = this.parameters.message === 'switch';
  // 功耗开关
  private powerTest: boolean = systemParameterEnhance.getSync('mediaController.powerTest', 'false') === 'true';
  @Provide isQuiting: boolean = false;
  @Provide isJumping: boolean = false;
  @State sysConfigData: SysConfigData | undefined = ThreadUtil.isMainThread ?
    MediaViewModelManager.getData(MediaVMType.SYS_CONFIG_DATA, true) as SysConfigData : undefined;

  aboutToAppear() {
    // 内存打点
    PerformanceReporter.getInstance().reportEnterMemScene(CurrentMemScene.MEDIA_CENTER);
    this.isQuiting = false;
    this.isJumping = false;
    if (!DropDownAdapter.isDropDownShow()) {
      log.showInfo('jump outside with no dropDownShow');
      this.controller.jumpOutside();
    }
  }

  aboutToDisappear(): void {
    // 内存打点
    PerformanceReporter.getInstance().reportExitMemScene(CurrentMemScene.MEDIA_CENTER);
    // 清空HisysEvent对象，释放内存
    HiSysEvent.clear();
  }

  getFontSizeScale() {
    // 隔离主线程调用
    if (ThreadUtil.isMainThread) {
      return this.sysConfigData?.fontSizeScale || 1;
    } else {
      return ResourceVm.instance.fontScale;
    }
  }

  /**
   * 关闭动画
   */
  disappear() {
    // 性能打点，退出播控
    performanceMonitor.begin('EXIT_CC_MEDIA_ANI', performanceMonitor.ActionType.LAST_UP);
    AppStorage.setOrCreate('showPlayLoading', false);
    this.controller.jumpOutside();
    this.isQuiting = true;
  }

  /**
   * 主页面
   */
  @Builder bodyBuilder() {
    ListDialog({
      isShowDev: $showDeviceList,
      showAnimateDone: $showAnimateDone,
      isShowDeviceAnim: $isShowDeviceAnim,
      disappear:() => {
        this.disappear()
      }
    })
    .align(Alignment.Center)
    .alignSelf(ItemAlign.Center)
    .key('media_control_card')
  }

  /**
   * 功耗页面
   */
  @Builder powerBuilder() {
    Column()
      .width('100%')
      .height('100%')
      .onClick(() => {
        this.controller.jumpOutside();
      })
  }

  build() {
    Column() {
      if (this.powerTest) {
        this.powerBuilder()
      } else if (!this.isJumping) {
        this.bodyBuilder()
      }
    }
    .width(Constants.MAX_WIDTH_AND_HEIGHT)
    .height(Constants.MAX_WIDTH_AND_HEIGHT)
    .backgroundColor(Constants.TRANSLUCENT_COLOR)
  }
}
