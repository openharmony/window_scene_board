/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import {
  SCBSceneContainerSession,
  SCBSceneMissionManager,
  SCBSceneSession,
  SCBSceneSessionManager
} from '../../../TsIndex';
import { SCBSceneInfo } from '../../session/SCBSceneInfo';
import { SCBMainSessionTuple, SCBStartSceneOpts } from '../missions/SCBSceneMissionTypes';
import { SCBScenePanelMissionHandler } from '../missions/SCBScenePanelMissionHandler';

const TAG: string = '[SCBMission]BasicSceneMissionTemplate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export interface MissionTemplateProcessor {
  getProcessor(): Function;
}

/**
 * Basic scene mission template for products to extend and integrate.
 */
export abstract class BasicSceneMissionTemplate<T extends SCBScenePanelMissionHandler>
  implements MissionTemplateProcessor {
  protected missionHandler: T;

  constructor(handler: T) {
    this.missionHandler = handler;
  }

  /**
   * name of template
   * @returns name
   */
  abstract getLogTag(): string;

  /**
   * implementation to process mission
   * @returns processor function
   */
  abstract getProcessor(): Function;

  /**
   * 查找或创建窗口会话和窗口容器会话
   *
   * @param sceneInfo - 窗口信息
   * @param opt - 窗口启动的可选参数
   * @returns
   *   - [SCBSceneSession, SCBSceneContainerSession]：包含窗口会话和窗口容器会话的元组
   *   - [null, null]：如果无法获取或创建会话
   */
  protected getOrCreateSceneAndContainerSession(sceneInfo: SCBSceneInfo,
    opt?: SCBStartSceneOpts): SCBMainSessionTuple {
    // find main session in current panel.
    let sessionTuple = this.missionHandler.getMainSessionTupleByInfo(sceneInfo);
    if (sessionTuple.sceneSession && sessionTuple.containerSession) {
      log.showInfo('find existing session in curren panel');
      return sessionTuple;
    }
    // find container session global.
    sessionTuple = SCBSceneMissionManager.getInstance().findMainSessionTupleGlobalByInfo(sceneInfo);
    if (sessionTuple.sceneSession && sessionTuple.containerSession) {
      const findRes = (sessionTuple.sceneSession.screenId === this.missionHandler.screenId) ?
        'cross panel' : 'cross screen';
      log.showWarn(`find existing session, but ${findRes}, will pop`);
      const sceneSession = SCBSceneSessionManager.getInstance().popSceneFromOtherScreen(sceneInfo);
      if (sceneSession) {
        log.showInfo('get sceneSession from screen: %{public}d', sceneSession.sceneInfo?.screenId);
        let newSceneSession = this.copySceneSession(sceneSession, sceneInfo);
        let newContainerSession = new SCBSceneContainerSession(newSceneSession, this.missionHandler.screenProperty);
        return { sceneSession: newSceneSession, containerSession: newContainerSession };
      } else {
        // existing session found, forbid starting.
        return { sceneSession: null, containerSession: null };
      }
    }

    // create new session
    sceneInfo.screenId = this.missionHandler.screenId;
    log.showInfo(`will create new session tuple with info: ${JSON.stringify(sceneInfo)}`);
    let sceneSession = SCBSceneMissionManager.getInstance().requestNewSceneSession(sceneInfo);
    if (sceneSession) {
      let containerSession = new SCBSceneContainerSession(sceneSession, this.missionHandler.screenProperty);
      return { sceneSession: sceneSession, containerSession: containerSession };
    }
    log.showError('create failed, null session.');
    return { sceneSession: null, containerSession: null };
  }

  /**
   * get exist main session tuple from panel handler.
   */
  public getExistMainSession(persistentId: number, info: SCBSceneInfo): SCBMainSessionTuple {
    let sessionTuple = this.missionHandler.getMainSessionTupleById(persistentId);
    if (!sessionTuple.sceneSession || !sessionTuple.containerSession) {
      sessionTuple = this.missionHandler.getMainSessionTupleByInfo(info);
    }
    return sessionTuple;
  }

  /**
   * 保留c++侧的session，将SCBSceneSession重新构建
   *
   * @param sceneSession - 要复制的窗口会话信息
   * @param sceneInfo - 窗口信息
   * @returns SCBSceneSession: 返回重新构建的窗口会话
   */
  protected copySceneSession(sceneSession: SCBSceneSession, sceneInfo: SCBSceneInfo): SCBSceneSession {
    const curScreenId = this.missionHandler.screenId;
    sceneInfo.persistentId = sceneSession.persistentId;
    sceneInfo.screenId = curScreenId;
    const newSceneSession: SCBSceneSession = new SCBSceneSession(sceneSession.session, sceneInfo);
    if (sceneSession.subSessionList.length !== 0) {
      sceneSession.subSessionList.forEach((item) => {
        SCBSceneSessionManager.getInstance().updateSessionDisplayId(item.session.persistentId, curScreenId);
        newSceneSession.subSessionList.push(item);
      });
    }
    if (sceneSession.dialogSessionList.length !== 0) {
      sceneSession.dialogSessionList.forEach((item) => {
        SCBSceneSessionManager.getInstance().updateSessionDisplayId(item.session.persistentId, curScreenId);
        newSceneSession.dialogSessionList.push(item);
      });
    }
    return newSceneSession;
  }
}