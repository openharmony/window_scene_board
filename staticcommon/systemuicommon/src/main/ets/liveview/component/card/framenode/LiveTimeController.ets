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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CustomPromise } from '@ohos/frameworkwrapper';
import { BaseNodeController } from '../../../../framenode/BaseNodeController';
import { LiveViewCommonConstants } from '../../../common/LiveConstants';
import { FrameCount } from '../../../../utils/FrameCount';
import { LiveTimeNode } from './LiveTimeNode';
import { LiveTimeParams } from './LiveTimeParams';

const TAG = LiveViewCommonConstants.LOG_PREFIX + 'LiveTimeController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class LiveTimeController extends BaseNodeController<LiveTimeParams> {
  /**
   * 预加载时间组件参数定义
   */
  private liveTimeParams: LiveTimeParams | null = null;
  /**
   * 分帧处理对象
   */
  private frameCount: FrameCount | null = null;
  private controllerInitPromise = new CustomPromise<void>();
  /**
   * 提前创建组件使用
   */
  private uiContext: UIContext | null = null;

  constructor(uiContext: UIContext, params: LiveTimeParams) {
    super(LiveTimeNode);
    this.uiContext = uiContext;
    this.setParams(params);

    // 启动帧渲染
    this.frameCount = new FrameCount(this.initLiveTimeNode);
    this.frameCount.start(3);
  }

  aboutToDisappear(): void {
    this.liveTimeParams?.timeData?.removeUpdateTimeCallback(this.updateTime);
  }

  /**
   * 设置组件参数
   * @param params
   */
  private setParams(params: LiveTimeParams) {
    this.liveTimeParams = params;
  }

  /**
   * 等待预加载节点创建完成后返回当前controller实例
   * @returns
   */
  public async getController() {
    await this.controllerInitPromise;
    return this;
  }

  private initLiveTimeNode = (count: number): void => {
    log.showInfo(`initLiveTimeNode, count: ${count}`);
    if (count === 1) {
      // 第一帧：等待当前组件渲染
      return;
    }

    if (count === 2) {
      // 第二帧：创建预加载节点
      if (this.uiContext !== null) {
        this.makeNode(this.uiContext);
        this.controllerInitPromise.resolve();
      }
      return;
    }

    // 第二帧：渲染数据
    this.render();
    this.liveTimeParams?.timeData?.addUpdateTimeCallback(this.updateTime)
  }

  /**
   * 触发渲染
   */
  private render() {
    if (this.liveTimeParams !== null) {
      this.update(this.liveTimeParams)
    }
  }

  /**
   * 更新相关系统资源
   */
  updateConfiguration() {
    if (this.node != null) {
      this.node.updateConfiguration()
    }
  }

  /**
   * 更新时间
   * @param timeText
   */
  private updateTime = (timeText: number) => {
    if (this.liveTimeParams?.timeData) {
      this.liveTimeParams.timeData.initialTime = timeText;
      this.update(this.liveTimeParams);
    }
  }
}