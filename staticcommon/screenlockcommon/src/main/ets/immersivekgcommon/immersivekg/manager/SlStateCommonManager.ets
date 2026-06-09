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
 * 通用锁屏状态管理器
 */
export class SlStateCmMgr extends SlStateBaseMgr {
  /**
   * 私有构造
   */
  private constructor() {
    super(SlStateMgr.MGR_COMMON);
  }

  /**
   * 实例获取
   *
   * @returns 实例
   */
  public static getInstance(): SlStateCmMgr {
    let mgr = SlStateBaseMgr.getMgr(SlStateMgr.MGR_COMMON);
    if (!mgr) {
      mgr = new SlStateCmMgr();
      SlStateBaseMgr.setMgr(SlStateMgr.MGR_COMMON, mgr);
    }
    return mgr;
  }
}