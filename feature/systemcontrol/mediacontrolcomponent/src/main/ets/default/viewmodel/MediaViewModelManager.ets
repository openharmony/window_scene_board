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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { BasicMediaData, BasicMediaVM } from './BasicMediaVM';
import { CommonMediaDataVM } from './CommonMediaDataVM';
import { SysConfigDataVM } from './SysConfigDataVM';

const TAG = 'MediaViewModelManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

export const enum MediaVMType {
  COMMON_MEDIA_DATA,
  SYS_CONFIG_DATA,
}

/*
  播控view model管理器，负责获取，创建，管理所有view model的生命周期
  每个view model作为一个单独模块，在需要时同时加载里面的view data和controller
 */
export class MediaViewModelManager {
  private static vmMap: Map<MediaVMType, BasicMediaVM> = new Map();

  /**
   * 获取对应类型的数据包，如果未初始化，会先进行初始化，获取后可直接与组件绑定刷新
   * @param vmType 数据包类型
   * @param isStrongRef 是否是强引用;如果会将返回值长期保存，需传入true，然后在释放的时候调用releaseData
   * @returns 对应类型数据包
   */
  public static getData(vmType: MediaVMType, isStrongRef: boolean): BasicMediaData {
    if (!MediaViewModelManager.vmMap.has(vmType)) {
      MediaViewModelManager.vmMap.set(vmType, MediaViewModelManager.createVM(vmType));
    }
    let vm = MediaViewModelManager.vmMap.get(vmType);
    if (!vm) {
      log.showError(`getData empty vm ${vmType}`);
      return new BasicMediaData();
    }
    return vm.getData(isStrongRef);
  }

  /**
   * 释放对应类型数据包，只有在获取时传入了isStrongRef为true时，才需要在释放的时候调用，用于动态清理不需要的vm
   * @param vmType 数据包类型
   */
  public static releaseData(vmType: MediaVMType): void {
    let vm = MediaViewModelManager.vmMap.get(vmType);
    if (!vm) {
      log.showInfo(`releaseData ${vmType} not found`);
      return;
    }
    let isFullRelease = vm.releaseData();
    if (isFullRelease) {
      log.showInfo(`releaseData full release ${vmType}`);
      MediaViewModelManager.vmMap.delete(vmType);
    }
  }

  private static createVM(vmType: MediaVMType): BasicMediaVM {
    switch (vmType) {
      case MediaVMType.COMMON_MEDIA_DATA:
        return CommonMediaDataVM.createInstance();
      case MediaVMType.SYS_CONFIG_DATA:
        return SysConfigDataVM.createInstance();
      default:
        return new BasicMediaVM();
    }
  }
}