/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { ImmersiveAnimScene } from '../../../../main/ets/common/anim/ImmersiveAnimConstants';
import { CapsulePositionType } from '../../../../main/ets/common/ImmersiveConstants';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveAnimManagerTest() {
  let viewArea: Area = {
    width: 100,
    height: 100,
    position: {
      x: 0, y: 0
    },
    globalPosition: {
      x: 0, y: 0
    }
  };
  describe('ImmersiveAnimManagerTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });
  });
}

/**
 * 动效结束类型
 */
type OnAnimFinish = () => void;

/**
 * 条目卡片参数传递
 */
interface ItemAnimParam {
  /**
   * 条目唯一标示
   */
  hashcode?: string;

  /**
   * 动效场景
   */
  animScene?: ImmersiveAnimScene;

  /**
   * 条目映射胶囊类型
   */
  mapCapsuleType?: CapsulePositionType;

  /**
   * 条目动效延时启动
   */
  animDelay?: number;

  /**
   * 是否为第一个条目
   */
  isFirstItem?: boolean;

  /**
   * 是否为最后一个条目
   */
  isLastItem?: boolean;

  /**
   * 条目索引
   */
  itemIndex?: number;

  /**
   * 条目可见起始索引
   */
  itemStartIndex?: number;

  /**
   * 条目可见结束索引
   */
  itemEndIndex?: number;

  /**
   * 速度
   */
  velocity?: number;

  /**
   * 是否为次要动效
   */
  isSecondaryAnim?: boolean;

  /**
   * 是否动效初始化
   */
  isAnimInit?: boolean;

  /**
   * 条目inner裁剪
   */
  isUseInnerClip?: boolean;

  /**
   * 参与动效条目标识集
   */
  itemList?: ItemAnimParam[];

  /**
   * 条目动效结束回调
   *
   * @param isLastItem 是否为最后一个条目
   */
  onAnimFinish?: (param: ItemAnimParam) => void;

  /**
   * 条目目标动作
   *
   * @param param 参数
   */
  tarItemAction?: (param: ItemAnimParam) => void;

  /**
   * 动效结束回调
   */
  callback?: OnAnimFinish;
}