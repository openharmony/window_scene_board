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
import { SlStateMgr } from '../constants/SlStateConst';
import { SlStateBaseMgr } from './SlStateBaseManager';

/**
 * 小外屏锁屏状态管理器
 */
export class SlStateOuterMgr extends SlStateBaseMgr {
  /**
   * 私有构造
   */
  private constructor() {
    super(SlStateMgr.MGR_OUTER_SCREEN);
  }

  /**
   * 获取实例
   *
   * @returns 实例
   */
  public static getInstance(): SlStateOuterMgr {
    let mgr = SlStateBaseMgr.getMgr(SlStateMgr.MGR_OUTER_SCREEN);
    if (!mgr) {
      mgr = new SlStateOuterMgr();
      SlStateBaseMgr.setMgr(SlStateMgr.MGR_OUTER_SCREEN, mgr);
    }
    return mgr;
  }
}