package com.projectERP.service.implementation;

import com.projectERP.exception.ResourceNotFoundException;
import com.projectERP.model.dto.LeaderProjectDto;
import com.projectERP.model.entity.LeaderProject;
import com.projectERP.repository.LeaderProjectRepo;
import com.projectERP.service.LeaderProjectService;
import lombok.AllArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class LeaderProjectServiceImpl implements LeaderProjectService {
    private LeaderProjectRepo leaderProjectRepo;
    private ModelMapper mapper;

    @Override
    public LeaderProjectDto create(LeaderProjectDto leaderProjectDto) {
        // convert DTO to entity
        LeaderProject leaderProject = mapToEntity(leaderProjectDto);
        LeaderProject newLeaderProject = leaderProjectRepo.save(leaderProject);

        // convert entity to DTO
        return mapToDTO(newLeaderProject);
    }

    @Override
    public List<LeaderProjectDto> getAll() {
        List<LeaderProject> leaderProjects = leaderProjectRepo.findAll();
        return leaderProjects.stream().map((leaderProject) -> mapToDTO(leaderProject))
                .collect(Collectors.toList());
    }

    @Override
    public List<LeaderProjectDto> findAll(String projectID) {
        List<LeaderProject> leaderProjects = leaderProjectRepo.findByProjectID(Long.valueOf(projectID));
        return leaderProjects.stream().map((leaderProject) -> mapToDTO(leaderProject))
                .collect(Collectors.toList());
    }

    @Override
    public List<LeaderProjectDto> findAllByLeaderID(String leaderID) {
        List<LeaderProject> leaderProjects = leaderProjectRepo.findByLeaderID(Long.valueOf(leaderID));
        return leaderProjects.stream().map((leaderProject) -> mapToDTO(leaderProject))
                .collect(Collectors.toList());
    }

    @Override
    public LeaderProjectDto getById(Long LeaderProjectID) {
        LeaderProject leaderProject = leaderProjectRepo.findById(LeaderProjectID).orElseThrow(
                () -> new ResourceNotFoundException("LeaderProject is not exist with given id : " + LeaderProjectID));

        return mapToDTO(leaderProject);
    }

    @Override
    public LeaderProjectDto getByLeaderIDAndProjectID(String leaderID, String projectID) {
        LeaderProject leaderProject = leaderProjectRepo.findByLeaderIDAndProjectID(Long.valueOf(leaderID),
                Long.valueOf(projectID));
        if (leaderProject != null) {
            return mapToDTO(leaderProject);
        } else {
            return null;
        }
    }

    @Override
    public void delete(Long LeaderProjectID) {
        LeaderProject leaderProject = leaderProjectRepo.findById(LeaderProjectID).orElseThrow(
                () -> new ResourceNotFoundException("LeaderProject is not exist with given id : " + LeaderProjectID));

        leaderProjectRepo.deleteById(LeaderProjectID);
    }

    // convert entity into DTO
    private LeaderProjectDto mapToDTO(LeaderProject leaderProject) {
        LeaderProjectDto leaderProjectDto = mapper.map(leaderProject, LeaderProjectDto.class);
        return leaderProjectDto;
    }

    // convert DTO to entity
    private LeaderProject mapToEntity(LeaderProjectDto leaderProjectDto) {
        LeaderProject leaderProject = mapper.map(leaderProjectDto, LeaderProject.class);
        return leaderProject;
    }
}
