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

import displaySync from '@ohos.graphics.displaySync';

import { DropDownEvent } from '@ohos/frameworkwrapper';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';

import { ControlCenterData } from '../common/Constants';
import { BrightnessSharedViewData } from '../viewModel/BrightnessViewModel';
import { BackgroundOpacity } from '../model/BrightnessViewData';
import { AnimationDataArray } from '../model/ControlCenterAnimationData';
import { ControlCenterLayoutIndex } from '../controller/ControlCenterLayoutController';
import { ControlListController } from '../controller/ControlListController';
import Controller from '../controller/ControlCenterController';

@Observed
export class ControlCenterViewData {
  /**
   * 是否触底
   */
  @Track public listController: ControlListController = new ControlListController();

  /**
   * list控制器
   */
  @Track public scroller: Scroller = new Scroller();

  /**
   * 创建DisplaySync对象，通过此对象设置UI自绘制内容帧率
   */
  @Track public displaySyncObject?: displaySync.DisplaySync;

  // 是否向下滑动过
  @Track public hasScrollDown: boolean = false;

  @Track public relativeDistance: number = 0;

  // 用于记录每次滑动开始的时候列表是否是触底状态
  @Track public startWhenListReachBottom: boolean = false;

  // 用于记录每次滑动开始的时候列表是否是触顶状态
  @Track public startWhenListReachTop: boolean = false;

  /**
   * y轴方向位移值
   */
  @Track public translateY: number = 0;

  /**
   * 下拉事件
   */
  @Track public dropDownEvent: DropDownEvent = DropDownPanelManager.getDropDownEvent();

  /**
   * 控制中心数据
   */
  @Track public data: ControlCenterData = Controller.getData();

  @Track public animationDataArray: AnimationDataArray = new AnimationDataArray();

  @Track public isHideAnimStarted: boolean = false;

  @Track public progress: number = 0;

  @Track public shouldClip: boolean = false;

  @Track public backgroundOpacity: BackgroundOpacity = BrightnessSharedViewData.getInstance().getBackgroundOpacity();

  @Track public openChain: boolean = true;

  @Track public isEditMode: boolean = false;

  /**
   * 控制中心ListItem索引集合
   * 默认为6行，即一行媒体卡片 + 三行快捷开关 + 一行亮度条 + 一行IOT卡片
   */
  @Track public contentIndexArr : string[] = [];

  @Track public ccLayoutIndex: ControlCenterLayoutIndex = ControlCenterLayoutIndex.NORMAL_PORTRAIT;
}