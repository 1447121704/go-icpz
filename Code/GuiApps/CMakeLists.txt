#/*============================================================================
#
#  GOICPZ: A software package for globally optimal implementations of the iterative closest point algorithm.
#
#  Copyright (c) University College London (UCL). All rights reserved.
#
#  This software is distributed WITHOUT ANY WARRANTY; without even
#  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#  PURPOSE.
#
#  See LICENSE.txt in the top level directory for details.
#
#============================================================================*/

if(BUILD_QTVTKGUI AND VTK_FOUND AND Qt5_DIR)
  add_subdirectory(QtVTK)
endif()

if(BUILD_QMLDEMO AND Qt5_DIR)
  add_subdirectory(QMLDemo)
endif()

