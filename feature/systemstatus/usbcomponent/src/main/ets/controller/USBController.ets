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

import commonEventManager from '@ohos.commonEventManager';
import CommonEventManager from '@ohos.commonEventManager';
import { LogDomain, LogHelper, SingletonHelper, } from '@ohos/basicutils';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { BusinessError } from '@kit.BasicServicesKit';
import { CapsuleVisibleEvent, EvtBus, PluginRequestEvent, PluginSlot } from '@ohos/frameworkwrapper';
import volumeManager from '@ohos.file.volumeManager';
import { USBDeviceInfo } from '../common/USBDeviceInfo';
import { USBUtil } from '../common/USBUtil';

const TAG = 'Model.USBController';
const DEFAULT_NAME = $r('app.string.usb_hover');
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const USB_VOLUME_MOUNTED_EVENT = CommonEventManager.Support.COMMON_EVENT_VOLUME_MOUNTED; // 提示已挂载外部存储设备
const USB_VOLUME_REMOVAL_EVENT = CommonEventManager.Support.COMMON_EVENT_VOLUME_BAD_REMOVAL; // 提示外部存储设备在挂载状态下被移除
const USB_VOLUME_UNMOUNTED_EVENT = CommonEventManager.Support.COMMON_EVENT_VOLUME_UNMOUNTED; // 提示已卸载外部存储设备
const USB_VOLUME_EJECT_EVENT = CommonEventManager.Support.COMMON_EVENT_VOLUME_EJECT; // 提示用户已作出弹出外部存储介质的操作

@Observed
export class USBLocalData {
}

export class USBController extends ToggleBaseViewModel {
  isAvailable(): boolean {
    return true;
  }

  private newState: boolean = false;
  private mUSBLocalData: USBLocalData = new USBLocalData();
  private subscriber: commonEventManager.CommonEventSubscriber | undefined = undefined;
  private subscriberRemove: commonEventManager.CommonEventSubscriber | undefined = undefined;
  private mUSBList: Array<USBDeviceInfo> = [];

  constructor() {
    super();
    this.onStart();
  }

  isPersist(): boolean {
    return true;
  }

  public static getInstance(): USBController {
    return SingletonHelper.getInstance(USBController, TAG);
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart');
    this.getViewData().icon = $r('sys.symbol.externaldrive');
    this.getViewData().label = DEFAULT_NAME;
    this.getViewData().isOn = true;
    this.mUSBList = [];
    AppStorage.setOrCreate('USBList', this.mUSBList);
    // 初始化USB列表
    volumeManager.getAllVolumes().then((data) => {
      if (data) {
        this.addUSBDeviceByVolumeList(data);
      }
      log.showInfo(`initialize usb info end`);
    }).catch((err: BusinessError) => {
      log.showInfo(`getAllVolumes error, msg:${err.message}`);
    });
    // 开启监听USB
    const subscribeInfoAdd: CommonEventManager.CommonEventSubscribeInfo = {
      events: [USB_VOLUME_MOUNTED_EVENT]
    };
    const subscribeInfoRemove: CommonEventManager.CommonEventSubscribeInfo = {
      events: [USB_VOLUME_REMOVAL_EVENT, USB_VOLUME_UNMOUNTED_EVENT, USB_VOLUME_EJECT_EVENT]
    };

    let updateUSBStatusAdd = (err: BusinessError, data: commonEventManager.CommonEventData) => {
      if (err) {
        log.showInfo(`Failed to subscribe. Code is ${err.code}, message is ${err.message}`);
      } else {
        if (data?.parameters) {
          log.showInfo(`detect new USB`);
          // uuid是唯一标识，如果uuid相同则认为是同一个外设设备
          let sameUSB = false;
          let fsUuid: string = data.parameters['fsUuid'] as string;
          this.mUSBList.forEach((mUSB) => {
            if (mUSB.uuid === fsUuid) {
              log.showInfo(`find sameUSB: ${mUSB.description}`);
              sameUSB = true;
              return;
            }
          });
          if (!sameUSB) {
            volumeManager.getVolumeByUuid(fsUuid).then((volume) => {
              this.addUSBDeviceByVolumeList([volume]);
            }).catch((err: BusinessError) => {
              log.error(`getVolumeByUuid error, mes:${err}`);
            });
          }
        }
      }
    }
    let updateUSBStatusRemove = (err: BusinessError, data: commonEventManager.CommonEventData) => {
      if (err) {
        log.showInfo(`Failed to subscribe. Code is ${err.code}, message is ${err.message}`);
      } else {
        log.showInfo(`remove usb`);
        if (data?.parameters) {
          let volumeId = data.parameters['id'] as string;
          this.updateUSBListByVolumeId(volumeId);
        }
      }
    }
    commonEventManager.createSubscriber(subscribeInfoAdd).then(curSubscriber => {
      this.subscriber = curSubscriber;
      commonEventManager.subscribe(this.subscriber, updateUSBStatusAdd);
    }).catch((err: BusinessError) => {
      log.error('commonEventManager subscribeInfoAdd error', err);
    });
    commonEventManager.createSubscriber(subscribeInfoRemove).then(curSubscriber => {
      this.subscriberRemove = curSubscriber;
      commonEventManager.subscribe(this.subscriberRemove, updateUSBStatusRemove);
    }).catch((err: BusinessError) => {
      log.error('commonEventManager subscribeInfoRemove error', err);
    });
    log.showInfo(`initialization end`);
  }

  updateUSBListByVolumeId(volumeId: string) {
    log.showInfo('updateUSBListByVolumeId enter');
    let index: number = -1;
    this.mUSBList.forEach((wUSB, curIndex: number) => {
      if (wUSB.volumeId === volumeId) {
        index = curIndex;
        return;
      }
    })
    if (index >= 0) {
      this.mUSBList.splice(index, 1);
      AppStorage.setOrCreate('USBList', this.mUSBList);
      log.showInfo('updateUSBListByVolumeId end');
    } else {
      log.warn('can not find usb when update');
    }
    this.isClose();
  }

  addUSBDeviceByVolumeList(volumeList: volumeManager.Volume[]) {
    if (!volumeList || volumeList.length <= 0) {
      log.showInfo('the res of getAllVolume is empty');
      return;
    }
    volumeList.forEach((volume) => {
      if (!volume.description || !volume.uuid) {
        log.warn('the description or uuid of cur usb is null');
        return;
      }
      log.showInfo('find usb (%{public}s):  %{private}s', volume.description, JSON.stringify(volume));
      let usbDevice: USBDeviceInfo = new USBDeviceInfo(volume.diskId, volume.id, volume.uuid, volume.description);
      const deviceId: string = USBUtil.isMtpDeviceByDeviceId(volume.id) ? volume.id : volume.uuid;
      usbDevice.uri = `file://docs/storage/External/${deviceId}`;
      usbDevice.relativePath = `/storage/External/${deviceId}`;
      usbDevice.path = volume.path;
      this.mUSBList.push(usbDevice);
    });


    AppStorage.setOrCreate('USBList', this.mUSBList);
    log.showInfo('add usb success');
    if (!this.newState) {
      this.handleStatusBarState();
    }
  }

  deleteUSBByVolumeId(volumeId: string) {
    if (volumeId) {
      log.showInfo(`delete usb volumeId: ${volumeId}`);
      volumeManager.unmount(volumeId).then(() => {
        log.info('usb removed end');
      }).catch((error: Error) => {
        log.error(`usb removed failed with error:  ${error?.message}`);
      });
    }
  }

  isClose() {
    if (this.mUSBList.length === 0 && this.newState) {
      this.handleStatusBarState();
      log.showInfo('close usb window');
    }
  }

  deleteCurUSB(mUSBDeviceInfo: USBDeviceInfo) {
    log.showInfo(`deleteUSB(${mUSBDeviceInfo.description}) enter`);
    let index: number = -1;
    this.mUSBList.forEach((wUSB, curIndex: number) => {
      if (wUSB.uuid === mUSBDeviceInfo.uuid) {
        index = curIndex;
        return;
      }
    })
    if (index >= 0) {
      this.deleteUSBByVolumeId(mUSBDeviceInfo.volumeId);
      this.mUSBList.splice(index, 1);
      AppStorage.setOrCreate('USBList', this.mUSBList);
      log.showInfo(`delete USB(${mUSBDeviceInfo.description}) end`);
    } else {
      log.warn(`can not find USB(${mUSBDeviceInfo.description}) when remove`);
    }
    this.isClose();
  }

  handleStatusBarState() {
    // 发送事件，触发PluginRootComponent组件中的状态更新，进而统一控制整个图标的显示与隐藏。
    this.newState = this.mUSBList.length > 0;
    log.showInfo(`handleStatusBarState, newState:${this.newState}`)
    this.sbPluginRequest.setIsVisible(this.newState);
    EvtBus.post(PluginRequestEvent, this.sbPluginRequest);

    // 胶囊事件
    EvtBus.post(CapsuleVisibleEvent, {
      pluginSlot: this.getSbPluginSlot(),
      visible: this.newState
    } as CapsuleVisibleEvent);
  }

  getUSBList(): Array<USBDeviceInfo> {
    return this.mUSBList.slice();
  }


  onStop(): void {
    log.showInfo('onStop');
    super.onStop();
    if (this.subscriber) {
      CommonEventManager.unsubscribe(this.subscriber);
      this.subscriber = undefined;
    }
    if (this.subscriberRemove) {
      CommonEventManager.unsubscribe(this.subscriberRemove);
      this.subscriberRemove = undefined;
    }
  }

  /**
   * USB图标标示
   */
  getSbPluginSlot(): string {
    return PluginSlot.SLOT_STATUS_USB;
  }

  getData(): USBLocalData {
    return this.mUSBLocalData;
  }

  handleOneClick(): void {
  }
}

let mUSBController = SingletonHelper.getInstance(USBController, TAG);

export default mUSBController as USBController;