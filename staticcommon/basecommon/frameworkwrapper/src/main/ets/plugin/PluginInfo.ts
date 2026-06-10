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

import type image from '@ohos.multimedia.image';
import { PluginParseInfo } from './PluginParseInfo';
import { PluginClickType } from './PluginConstants';
import type { Equality } from '@ohos/basicutils';
import PCM from '@ohos.pluginComponent';
// import statusBar from '@hms.pcService.statusBar';

/**
 * plugin化接入，组件数据信息
 * 主要用于状态栏、控制中心接入
 *
 * @since 2022-10-13
 */
export class PluginInfo implements Equality {
  /**
   * plugin解析配置数据
   */
  pluginParseInfo: PluginParseInfo;

  requestPids: number[] = [];

  /**
   * 相等比较
   *
   * @param other 待比较
   */
  equals(other: object): boolean {
    if (other instanceof PluginInfo) {
      return this.pluginParseInfo?.equals(other.pluginParseInfo);
    }
    return false;
  }

  /**
   * 判断是否有点击弹窗
   *
   * @return true有点击弹窗
   */
  hasClickWindow(): boolean {
    let clickType = this.pluginParseInfo?.clickInfo?.clickType;
    return clickType === PluginClickType.TYPE_WINDOW;
  }

  /**
   * 判断是否有点击弹窗
   *
   * @return true有点击弹窗
   */
  hasSubPage(): boolean {
    let clickType = this.pluginParseInfo?.subPageClickInfo?.clickType;
    return clickType === PluginClickType.TYPE_WINDOW;
  }

  /**
   * 获取图标slot
   *
   * @returns 图标slot
   */
  getSlot(): string {
    return this.pluginParseInfo?.pluginSlot ?? '';
  }

  /**
   * 图标是否为本地图标或通过配置文件接入
   *
   * @returns
   */
  isConfigOrLocalPlugin(): boolean {
    return true;
  }

  /**
   * 资源回收
   */
  onDestroy(): void {}
}

/**
 * plugin接入，本地plugin数据信息
 */
export class PluginLocalInfo extends PluginInfo {
  /**
   * 图标名称，null不显示
   */
  label?: string;

  /**
   * 图标，null不显示
   */
  icon?: Resource;

  /**
   * 最大自适应宽度
   */
  maxAutoWidth?: number = MAX_AUTO_WIDTH;

  /**
   * 图标颜色
   */
  contentColor?: string;
}

const MAX_AUTO_WIDTH = 140;

/**
 * plugin接入，远程plugin组件接入信息
 */
export class PluginComponentInfo extends PluginInfo {
  /**
   * plugin接入应用ability
   */
  templateAbility: string;

  /**
   * plugin模板名
   */
  templateSource: string;

  /**
   * plugin组件加载时填充数据
   */
  pluginData: PCM.KVObject;

  /**
   * 远程应用请求icon组件宽度
   */
  requestWidth: number = 0;

  /**
   * 远程应用请求图标是否可见
   */
  requestVisible: boolean = true;

  /**
   * 远程应用请求关闭弹窗
   */
  requestCloseWindow: boolean = false;

  /**
   * 远程应用请求弹窗高度
   */
  requestWindowHeight: number = 0;

  /**
   * 远程应用请求销毁
   */
  requestDestroyWindow: boolean = true;

  /**
   * 图标颜色
   */
  contentColor?: string;

  /**
   * 远程应用进程号
   */
  requestPid?: number;

  /**
   * 远程应用所属用户id，用来限制跨用户行为
   */
  requestUserId?: number;

  /**
   * 远程应用请求打开弹窗
   */
  requestOpenWindow: boolean = false;
}

export class PluginAccessInfo extends PluginInfo {

  title: string;

  /**
   * 第三方应用接入的图标的tokenId
   */
  accessTokenId: number;

  /**
   * 第三方应用调用添加图标的前台进程ID
   */
  pids: Set<number>;

  /**
   * 元能力绑定到该图标上的进程id集合
   */
  attachPids: Set<number>;

  /**
   * 第三方接入图标
   */
  icon: {
    white: image.PixelMap,
    black: image.PixelMap,
  };
  /**
   * 右键菜单数据
   */
  // menuInfo?: statusBar.StatusBarGroupMenu[];

  /**
   * 二级菜单动效使能
   */
  loadingStatus: boolean = false;

  equals(other: object): boolean {
    if (other instanceof PluginAccessInfo) {
      return other.accessTokenId === this.accessTokenId &&
        other.pluginParseInfo?.instanceKey === this.pluginParseInfo?.instanceKey &&
        other.pluginParseInfo?.action === this.pluginParseInfo?.action;
    }
    return false;
  }

  getSlot(): string {
    if (this.pluginParseInfo) {
      return this.pluginParseInfo.pluginSlot + this.pluginParseInfo.instanceKey;
    }
    return '';
  }

  isConfigOrLocalPlugin(): boolean {
    return false;
  }

  onDestroy(): void {
    this.icon?.white?.release();
    this.icon?.black?.release();
  }
}