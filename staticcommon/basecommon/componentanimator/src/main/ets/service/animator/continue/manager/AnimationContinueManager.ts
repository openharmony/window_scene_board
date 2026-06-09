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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { AnimationViewData, AnimationViewDataList } from '../../common/viewmodel/AnimationViewData';

const TAG: string = 'AnimationContinueManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 动效衔接组件的管理类
 */
class AnimationContinueManager {
  private continueData: AnimationViewDataList = new AnimationViewDataList();
  private dataMap: Map<string, AnimationViewData> = new Map();

  /**
   * 获取所有动效衔接参数数组
   *
   * @returns 所有动效衔接组件参数数组
   */
  public getAllData(): AnimationViewDataList {
    return this.continueData;
  }

  /**
   * 增加动效衔接参数
   *
   * @param data 动效衔接参数
   */
  public addData(data: AnimationViewData): void {
    log.showInfo(`add continue data:${data.toString()}`);
    this.release(data.key);
    this.continueData.push(data);
    this.dataMap.set(data.key, data);
  }

  /**
   * 显示动效衔接组件
   *
   * @param key 动效衔接组件的标识符
   */
  public show(key: string): void {
    let data = this.dataMap.get(key);
    if (data != null) {
      log.showInfo(`show continue image with key:${key}`);
      data.isShow = true;
    }
  }

  /**
   * 释放动效衔接组件，删除其数据
   *
   * @param key 动效衔接组件的标识符
   */
  public release(key: string): void {
    let data = this.dataMap.get(key);
    if (data != null) {
      log.showInfo(`release continue image with key:${key}`);
      data.pixmap?.release();
      this.dataMap.delete(key);
      let index = this.continueData.indexOf(data);
      this.continueData.splice(index, 1);
    }
  }

  /**
   * 获取动效衔接参数
   *
   * @param key 动效衔接组件的标识符
   * @returns 动效衔接参数
   */
  public getData(key: string): AnimationViewData | undefined {
    return this.dataMap.get(key);
  }

  /**
   * 释放所有动效衔接组件，清空所有参数
   */
  public releaseAll(): void {
    log.showInfo('release all continue item');
    this.continueData.forEach((value: AnimationViewData) => value.pixmap?.release());
    this.continueData.splice(0, this.continueData.length);
    this.dataMap.clear();
  }
}

export const animationContinueManager: AnimationContinueManager =
  SingletonHelper.getInstance(AnimationContinueManager, TAG);