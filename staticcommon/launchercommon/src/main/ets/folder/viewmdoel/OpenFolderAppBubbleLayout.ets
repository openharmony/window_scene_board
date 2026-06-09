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
import { LogDomain, Logger, SingletonHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { AppIconData } from '../../launchericon/viewmodel/AppIconData';
import { AppNameVm } from '../../launchericon/viewmodel/AppNameVm';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { AppStatus, CommonConstants } from '../../constants/CommonConstants';

const TAG: string = 'OpenFolderAppBubbleLayout';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * 文件夹展开态内的图标布局参数管理,包含图标布局参数和名称布局参数
 */
export class OpenFolderAppBubbleLayout {
  protected iconItems: Map<string, AppIconData> = new Map();

  private nameItems: Map<string, AppNameVm> = new Map();

  public setIconData(keyName: string, iconData: AppIconData): void {
    log.showInfo(TAG, `setIconData ${keyName}`);
    this.iconItems.set(keyName, iconData);
  }

  public deleteIconData(keyName: string): void {
    log.showInfo(TAG, `deleteIconData ${keyName}`);
    this.iconItems.delete(keyName);
  }

  public setNameData(keyName: string, nameData: AppNameVm): void {
    log.showInfo(TAG, `setNameData ${keyName}`);
    this.nameItems.set(keyName, nameData);
  }

  public deleteNameData(keyName: string): void {
    log.showInfo(TAG, `deleteNameData ${keyName}`);
    this.nameItems.delete(keyName);
  }

  public getIconData(keyName: string, bundleName?: string): AppIconData {
    let findIconData: AppIconData | undefined = this.iconItems.get(keyName);

    // 对于安装中到安装完成短暂状态文件夹关闭需要用安装中的iconData做动效
    if (!findIconData && bundleName) {
      findIconData = this.iconItems.get(bundleName);
      if (!findIconData) {
        log.showInfo(TAG, `getIconData fail 1 ${keyName}`);
        findIconData = new AppIconData();
        this.setIconData(bundleName, findIconData);
      }
      return findIconData;
    }
    if (!findIconData) {
      findIconData = new AppIconData();
      log.showInfo(TAG, `getIconData fail 2 ${keyName}`);
      this.setIconData(keyName, findIconData);
    }
    return findIconData;
  }

  public getNameData(keyName: string, bundleName?: string): AppNameVm {
    let findNameData: AppNameVm | undefined = this.nameItems.get(keyName);

    // 对于安装中到安装完成短暂状态文件夹关闭需要用安装中的nameData做动效
    if (!findNameData && bundleName) {
      findNameData = this.nameItems.get(bundleName);
      if (!findNameData) {
        log.showInfo(TAG, `getNameData fail 1 ${keyName}`);
        findNameData = new AppNameVm();
        this.setNameData(bundleName, findNameData);
      }
      return findNameData;
    }
    if (!findNameData) {
      log.showInfo(TAG, `getNameData fail 2 ${keyName}`);
      findNameData = new AppNameVm();
      this.setNameData(keyName, findNameData);
    }
    return findNameData;
  }

  /**
   * 还原对应展开态图标的动效相关属性值，由于当前拖出文件夹时不会刷新展开态的数据导致拖出元素在关闭时同步被修改了动效相关属性值，
   * 数据归一后删除此接口
   *
   * @param keyName 图标对应的标识符
   */
  public revertAppData(item: GridLayoutItemInfo, msg?: string): void {
    let keyName: string = item.keyName as string;
    const iconData: AppIconData = this.getIconData(keyName);
    iconData.setIsLock(false, msg ?? `revertAppData ${keyName}`);
    iconData.setIconScale(1);
    iconData.setIconOpacity(1, TAG, 'revertAppData');
    iconData.transX = 0;
    iconData.transY = 0;
    // 克隆过来的占位的快捷方式图标使用的自定义蒙层，处于占位状态不能清空蒙层
    const isPendShortcut: boolean =
      item.typeId === CommonConstants.TYPE_SHORTCUT_ICON && item.appStatus === AppStatus.PENDING;
    if (iconData.isShowMask && !isPendShortcut) {
      iconData.isShowMask = false;
    }
    this.getNameData(keyName).modifier.attribute?.opacity(1);
  }

  public release(): void {
    this.iconItems.clear();
  }
}

// 单例
export let openFolderAppBubbleLayout: OpenFolderAppBubbleLayout = SingletonHelper
  .getInstance(OpenFolderAppBubbleLayout, TAG);